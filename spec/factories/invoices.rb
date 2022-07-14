# frozen_string_literal: true

FactoryBot.define do
  factory :invoice do
    merchant 
    customer 
    status { 'status' }
  end
end
