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

    item = JSON.parse(response.body, symbolize_names: true)[:data]

    expect(item[:id]).to eq(id.to_s)
    
    expect(item[:attributes]).to include(:name, :description, :unit_price, :merchant_id)
    expect(item[:attributes][:name]).to be_a(String)
    expect(item[:attributes][:description]).to be_a(String)
    expect(item[:attributes][:unit_price]).to be_a(Float)
    expect(item[:attributes][:merchant_id]).to be_an(Integer)

  end

  it "can create a new item" do
    id = create(:merchant).id
    item_params = ({
                    name: "Schmidts Suede Pants",
                    description: "I can't cure damaged suede",
                    unit_price: 199.0,
                    merchant_id: id
                  })
     post '/api/v1/items', params: { item: item_params }, as: :json
     
     expect(response).to be_successful

     item = Item.last
    #  require 'pry'; binding.pry
     expect(item.id).to be_an(Integer)
     expect(item.name).to eq("Schmidts Suede Pants")
     expect(item.description).to eq("I can't cure damaged suede")
     expect(item.unit_price).to eq(199.0)
     expect(item.merchant_id).to eq(id)
  end
  
  
  
end
