FactoryBot.define do 
  factory :user do 
    username { Faker::Name.name }
    email { Faker::Internet.email }
  end

  trait :admin do
    is_admin { true }
  end
end