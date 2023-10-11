FactoryBot.define do
  factory :user do
    name { Faker::Lorem.word }
    login { Faker::Lorem.word }
    password { Faker::Lorem.word }
  end
end
