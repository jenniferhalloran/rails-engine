# frozen_string_literal: true

require 'rails_helper'

RSpec.describe 'Items API' do
  it 'sends a list of items' do
    id = create(:merchant).id
    create_list(:item, 3, merchant_id: id)

    get '/api/v1/items'

    expect(response).to be_successful

    items = JSON.parse(response.body, symbolize_names: true)[:data]

    expect(items.count).to eq(3)

    items.each do |item|
      expect(item).to have_key(:id)
      expect(item[:attributes]).to include(:name, :description, :unit_price, :merchant_id)

      expect(item[:attributes][:name]).to be_a(String)
      expect(item[:attributes][:description]).to be_a(String)
      expect(item[:attributes][:unit_price]).to be_a(Float)
      expect(item[:attributes][:merchant_id]).to eq(id)
    end
  end

  it "can return one item by its id" do
    id = create(:item).id
    
    get "/api/v1/items/#{id}"

    expect(response).to be_successful    
  end
  
end
