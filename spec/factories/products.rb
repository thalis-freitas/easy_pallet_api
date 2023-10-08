FactoryBot.define do
  factory :product do
    name { Faker::Lorem.sentence.upcase }
    ballast { Faker::Number.number(digits: rand(1..3)).to_s }
  end
end
