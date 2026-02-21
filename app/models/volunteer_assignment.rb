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

  # ... existing code ...

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
