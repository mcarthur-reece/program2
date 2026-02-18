FactoryBot.define do
  factory :admin do
    sequence(:username) { |n| "admin#{n}" }
    password { "password123" }
    password_confirmation { "password123" }
    sequence(:name) { |n| "Admin User #{n}" }
    sequence(:email) { |n| "admin#{n}@example.com" }

    # Trait for creating without associations (useful later)
    trait :with_password do
      after(:build) do |admin|
        admin.password = "password123"
        admin.password_confirmation = "password123"
      end
    end
  end
end
