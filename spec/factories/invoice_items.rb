# frozen_string_literal: true

FactoryBot.define do
  factory :invoice_item do
    item 
    invoice 
    quantity { Faker::Number.between(from: 1, to: 100) }
    unit_price { Faker::Number.between(from: 1, to: 10_000) }
  end
end
