# frozen_string_literal: true

require 'rails_helper'

RSpec.describe 'Items API' do
  it 'sends a list of items' do
    id = create(:merchant).id
    create_list(:item, 3, merchant_id: id)

    get '/api/v1/items'

    expect(response.status).to eq(200)

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

  it 'can return one item by its id' do
    id = create(:item).id

    get "/api/v1/items/#{id}"

    expect(response.status).to eq(200)

    item = JSON.parse(response.body, symbolize_names: true)[:data]

    expect(item[:id]).to eq(id.to_s)

    expect(item[:attributes]).to include(:name, :description, :unit_price, :merchant_id)
    expect(item[:attributes][:name]).to be_a(String)
    expect(item[:attributes][:description]).to be_a(String)
    expect(item[:attributes][:unit_price]).to be_a(Float)
    expect(item[:attributes][:merchant_id]).to be_an(Integer)
  end

  it 'can create a new item' do
    id = create(:merchant).id
    item_params = {
      name: 'Schmidts Suede Pants',
      description: "I can't cure damaged suede",
      unit_price: 199.0,
      merchant_id: id
    }
    post '/api/v1/items', params: { item: item_params }, as: :json

    expect(response.status).to eq(201)

    item = Item.last

    expect(item.id).to be_an(Integer)
    expect(item.name).to eq('Schmidts Suede Pants')
    expect(item.description).to eq("I can't cure damaged suede")
    expect(item.unit_price).to eq(199.0)
    expect(item.merchant_id).to eq(id)
  end

  it 'can edit an existing item' do
    id = create(:item).id
    previous_description = Item.last.description
    item_params = { description: 'No. Please take that off. You look like a homeless Pencil.' }

    patch "/api/v1/items/#{id}", params: { item: item_params }, as: :json

    item = Item.find(id)

    expect(response.status).to eq(200)
    expect(item.description).to_not eq(previous_description)
    expect(item.description).to eq('No. Please take that off. You look like a homeless Pencil.')
  end

  it 'returns a 404 error if the id is a string' do
    item = create(:item)
    item_params = { merchant_id: '99' }

    patch "/api/v1/items/#{item.id}", params: { item: item_params }, as: :json

    expect(response.status).to eq(404)

    expect(item.id).to_not eq('99')
  end

  it 'can delete an item' do
    item = create(:item)

    delete "/api/v1/items/#{item.id}"

    expect(response).to be_successful
    expect { Item.find(item.id) }.to raise_error(ActiveRecord::RecordNotFound)
  end

  it 'can return the merchant associated with an item' do
    id = create(:merchant).id
    item = create(:item, merchant_id: id)

    get "/api/v1/items/#{item.id}/merchant"

    expect(response.status).to eq(200)

    merchant = JSON.parse(response.body, symbolize_names: true)[:data]

    expect(merchant).to have_key(:id)

    expect(merchant[:attributes]).to have_key(:name)
    expect(merchant[:attributes][:name]).to be_a(String)
  end

  it 'can return all items that match a search term' do
    item1 = create(:item, name: 'Backpack')
    item2 = create(:item, name: 'Hiking Boots')
    item2 = create(:item, name: 'Gumboot')
    item3 = create(:item, name: 'Tent')
    item4 = create(:item, name: 'Harness')

    get '/api/v1/items/find_all?name=boot'

    expect(response.status).to eq(200)

    items = JSON.parse(response.body, symbolize_names: true)[:data]
    expect(items.count).to eq(2)

    items.each do |item|
      expect(item).to have_key(:id)
      expect(item[:attributes]).to include(:name, :description, :unit_price, :merchant_id)

      expect(item[:attributes][:name]).to be_a(String)
      expect(item[:attributes][:description]).to be_a(String)
      expect(item[:attributes][:unit_price]).to be_a(Float)
      expect(item[:attributes][:merchant_id]).to be_an(Integer)
    end
  end

  it 'does not return a 404 error if there are no matches' do
    create(:item, name: 'Backpack')
    create(:item, name: 'Tent')
    create(:item, name: 'Harness')

    get '/api/v1/items/find_all?name=boot'

    expect(response.status).to eq(200)

    result = JSON.parse(response.body, symbolize_names: true)

    expect(result).to have_key(:data)
    expect(result[:data]).to eq([])
  end
end
