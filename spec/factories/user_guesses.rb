FactoryBot.define do
  factory :user_guess do
    association :user
  end

  trait :expired do 
    created_at { 2.hours.ago }
  end 
end