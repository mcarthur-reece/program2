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
    errors.add(:event, "is not open for sign-ups") unless event.open?
  end

  def event_must_have_available_slots
    return if event.blank?
    errors.add(:event, "is full") unless event.slots_available?
  end

  def hours_can_only_be_logged_for_completed_assignment
    return if hours_worked.blank? && date_logged.blank?

    errors.add(:hours_worked, "can only be logged for completed assignments") unless completed?
    errors.add(:date_logged, "must be present when logging hours") if date_logged.blank?
  end

  def cannot_complete_assignment_unless_event_completed
    return unless completed?
    return if event.blank?

    errors.add(:status, "cannot be completed unless the event is completed") unless event.completed?
  end

  def hours_cannot_exceed_event_duration
    return if hours_worked.blank?
    return if event.blank? || event.start_time.blank? || event.end_time.blank?

    duration = event.duration_hours
    return if duration.nil?

    errors.add(:hours_worked, "cannot exceed the event duration (#{duration} hours)") if hours_worked.to_d > duration.to_d
  end

  def sync_event_fullness!
    return if event.blank?
    return if event.completed?

    approved_count = event.volunteer_assignments.approved.count

    if approved_count >= event.required_number_of_volunteers
      event.update!(status: :full) unless event.full?
    else
      event.update!(status: :open) unless event.open?
    end
  end
end
