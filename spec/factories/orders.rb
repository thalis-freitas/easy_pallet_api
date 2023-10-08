FactoryBot.define do
  factory :order do
    code { Faker::Alphanumeric.alphanumeric(number: 9).upcase }
    bay { Faker::Alphanumeric.alphanumeric(number: 3).upcase }
    association :load
  end
end
