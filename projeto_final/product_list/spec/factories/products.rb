FactoryBot.define do
  factory :product do
    name { Faker::Commerce.product_name }
    description { Faker::Lorem.paragraph(sentence_count: 2) }
    value { Faker::Commerce.price(range: 1.0..1000.0) }
    quantity { Faker::Number.between(from: 1, to: 100) }
    available { true }
  end
end
