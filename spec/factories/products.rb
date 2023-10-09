FactoryBot.define do
  factory :product do
    name { Faker::Lorem.sentence.upcase }
    ballast { rand(1..200).to_s }
  end
end
