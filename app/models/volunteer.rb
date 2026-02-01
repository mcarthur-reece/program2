class Volunteer < ApplicationRecord
  has_secure_password validations: false  # Disable default validations
  
  # Callbacks
  before_save :downcase_email
  
  # Validations
  validates :username, presence: true, uniqueness: true
  validates :full_name, presence: true
  validates :email, presence: true, uniqueness: { case_sensitive: false }, 
            format: { with: URI::MailTo::EMAIL_REGEXP, message: "must be a valid email address" }
  validates :password, presence: true, length: { minimum: 6 }, if: -> { new_record? || !password.nil? }
  validates :password_confirmation, presence: true, if: -> { password.present? }
  validate :password_must_not_be_whitespace
  
  # Future associations (Person 2 will add these)
  # has_many :volunteer_assignments, dependent: :destroy
  # has_many :events, through: :volunteer_assignments
  
  private
  
  def downcase_email
    self.email = email.downcase if email.present?
  end
  
  def password_must_not_be_whitespace
    if password.present? && password.match?(/\A\s+\z/)
      errors.add(:password, "can't be blank")
    end
  end
end