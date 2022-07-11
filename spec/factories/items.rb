# frozen_string_literal: true

FactoryBot.define do
  factory :item do
    association :merchant
    name { Faker::Commerce.product_name }
    description { Faker::TvShows::NewGirl.quote }
    unit_price { Faker::Number.between(from: 1, to: 300_000) }
  end
end
