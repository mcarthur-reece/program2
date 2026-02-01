class Volunteer < ApplicationRecord
  has_secure_password
  
  # Validations
  validates :username, presence: true, uniqueness: true
  validates :full_name, presence: true
  validates :email, presence: true, uniqueness: true, 
            format: { with: URI::MailTo::EMAIL_REGEXP, message: "must be a valid email address" }
  validates :password, length: { minimum: 6 }, if: -> { new_record? || !password.nil? }
  
  # Future associations (Person 2 will add these)
  # has_many :volunteer_assignments, dependent: :destroy
  # has_many :events, through: :volunteer_assignments
end