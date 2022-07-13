# frozen_string_literal: true

FactoryBot.define do
  factory :invoice_item do
    item { nil }
    invoice { nil }
    quantity { 1 }
    unit_price { 1.5 }
  end
end
