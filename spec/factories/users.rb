FactoryBot.define do
    factory :user do
      sequence(:email) { |n| "user#{n}@example.com" }
      password { 'password' }
      full_name { 'John Doe' }
    end
  end
  