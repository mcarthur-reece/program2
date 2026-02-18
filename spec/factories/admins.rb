FactoryBot.define do
  factory :admin do
    sequence(:username) { |n| "admin#{n}" }
    password { "password123" }
    password_confirmation { "password123" }
    sequence(:name) { |n| "Admin User #{n}" }
    sequence(:email) { |n| "admin#{n}@example.com" }
  end
end
