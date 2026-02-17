# app/models/event.rb
class Event < ApplicationRecord
  enum :status, { open: 0, full: 1, completed: 2 }

  has_many :volunteer_assignments, dependent: :destroy
  has_many :volunteers, through: :volunteer_assignments

  validates :title, :description, :location, :event_date, :start_time, :end_time, presence: true
  validates :required_number_of_volunteers, presence: true,
            numericality: { only_integer: true, greater_than: 0 }
  validates :status, presence: true

  validate :start_time_must_be_before_end_time

  after_initialize do
    self.status ||= :open if new_record?
  end

  def duration_hours
    return nil if start_time.blank? || end_time.blank?
    ((end_time - start_time) / 3600.0)
  end

  def approved_volunteer_count
    volunteer_assignments.approved.count
  end

  def slots_available?
    open? && approved_volunteer_count < required_number_of_volunteers.to_i
  end

  private

  def start_time_must_be_before_end_time
    return if start_time.blank? || end_time.blank?
    return if start_time < end_time

    errors.add(:start_time, "must be before end time")
  end
end