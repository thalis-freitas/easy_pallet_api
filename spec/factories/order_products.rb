FactoryBot.define do
  factory :order_product do
    association :order
    association :product
    quantity { rand(1..300).to_s }
  end
end
