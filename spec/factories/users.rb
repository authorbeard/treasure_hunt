FactoryBot.define do 
  factory :user do 
    username { Faker::Name.name }
    email { Faker::Internet.email }
  end

  trait :admin do
    is_admin { true }
  end

  trait :winner do
    winning_guess { [1,1] }
    winning_distance { 0.5 }
  end
end