FactoryBot.define do
    factory :user do
        full_name { 'John Doe' }
        email { 'john.doe@example.com' }
        password { 'password123' }
      end

    factory :category do
      # Category factory attributes
      name { 'Sample Category' }
      user
    end
  
    factory :transaction do
      # Transaction factory attributes
      name { 'Sample Transaction' }
      amount { 100 }
      category
    end
  end
  