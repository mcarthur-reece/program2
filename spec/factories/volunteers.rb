FactoryBot.define do
  factory :volunteer do
    sequence(:username) { |n| "volunteer#{n}" }
    password { "password123" }
    password_confirmation { "password123" }
    sequence(:full_name) { |n| "Volunteer User #{n}" }
    sequence(:email) { |n| "volunteer#{n}@example.com" }
    phone_number { "123-456-7890" }
    address { "123 Main St, City, State 12345" }
    skills_interests { "Community service, teaching, organizing events" }
    total_hours { 0.0 }

    # Trait for creating without associations (useful later)
    trait :with_password do
      after(:build) do |volunteer|
        volunteer.password = "password123"
        volunteer.password_confirmation = "password123"
      end
    end
  end
end
