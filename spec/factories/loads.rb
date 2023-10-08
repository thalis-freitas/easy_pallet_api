FactoryBot.define do
  factory :load do
    code { Faker::Alphanumeric.alphanumeric(number: 8).upcase }
    delivery_date { Faker::Date.between(from: 1.week.ago, to: 1.week.from_now) }
  end
end
