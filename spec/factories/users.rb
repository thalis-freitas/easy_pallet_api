FactoryBot.define do
  factory :user do
    name { Faker::Lorem.word }
    sequence(:login) { |n| "#{Faker::Lorem.word}#{n}" }
    password { Faker::Lorem.characters(number: 4) }
  end
end
