# frozen_string_literal: true

FactoryBot.define do
  factory :invoice do
    merchant { nil }
    customer { nil }
    status { 'MyString' }
  end
end
