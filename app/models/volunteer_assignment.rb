class VolunteerAssignment < ApplicationRecord
  belongs_to :volunteer
  belongs_to :event

  enum :status, { pending: 0, approved: 1, completed: 2, cancelled: 3 }

  validates :status, presence: true
  validates :volunteer_id, uniqueness: { scope: :event_id }

  validates :hours_worked,
            numericality: { greater_than_or_equal_to: 0 },
            allow_nil: true

  validate :event_must_be_open_for_signup, on: :create
  validate :event_must_have_available_slots, on: :create
  validate :hours_can_only_be_logged_for_completed_assignment
  validate :cannot_complete_assignment_unless_event_completed
  validate :hours_cannot_exceed_event_duration

  after_commit :sync_event_fullness!, on: [:create, :update, :destroy]

  private

  def event_must_be_open_for_signup
    return if event.blank?

    # Volunteers should not be able to sign up for events that are full or completed.
    unless event.open?
      errors.add(:base, "This event is not open for sign-ups.")
    end
  end

  def event_must_have_available_slots
    return if event.blank?

    # IMPORTANT: pending sign-ups do NOT consume capacity (per spec),
    # so only approved assignments count toward fullness.
    approved_count = event.volunteer_assignments.approved.count

    if approved_count >= event.required_number_of_volunteers.to_i
      errors.add(:base, "This event is full.")
    end
  end

  def hours_can_only_be_logged_for_completed_assignment
    # Only volunteers who are assigned to a completed event can have hours logged.
    return if hours_worked.blank? && date_logged.blank?

    unless completed?
      errors.add(:hours_worked, "can only be logged when the assignment is completed")
      errors.add(:date_logged, "can only be set when the assignment is completed") if date_logged.present?
    end
  end

  def cannot_complete_assignment_unless_event_completed
    return if event.blank?
    return unless completed?

    # Assignment can only be completed after the associated event is completed.
    unless event.completed?
      errors.add(:status, "cannot be completed unless the event is marked completed")
    end
  end

  def hours_cannot_exceed_event_duration
    return if hours_worked.blank?
    return if event.blank?

    duration = event.duration_hours
    return if duration.nil?

    if hours_worked.to_f > duration.to_f
      errors.add(:hours_worked, "cannot exceed the event duration (#{duration.round(2)} hours)")
    end
  end

  def sync_event_fullness!
    return if event.blank?

    # When an Event is being destroyed (and it destroys assignments),
    # Rails may freeze the event instance. Never try to update it then.
    return if event.destroyed? || event.frozen? || event.completed?

    approved_count = event.volunteer_assignments.approved.count

    if approved_count >= event.required_number_of_volunteers
      event.update!(status: :full) unless event.full?
    else
      event.update!(status: :open) unless event.open?
    end
  end
end
