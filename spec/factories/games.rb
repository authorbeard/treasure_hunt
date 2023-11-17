FactoryBot.define do 
  factory :game do 
    name { Faker::Name.name }
    address { "Change.org, 548, Market Street, Transbay, San Francisco, California, 94104, United States" }
    latitude { 37.7899932 }
    longitude { -122.4008494 }
  end
end