# frozen_string_literal: true

require 'rails_helper'

RSpec.describe 'Items API' do

  describe 'GET /api/v1/items endpoint' do
    describe 'happy path' do
      it 'gets all items' do
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

      it 'returns an array of data even if there is one item found' do
        create(:item)

        get '/api/v1/items'

        expect(response.status).to eq(200)

        items = JSON.parse(response.body, symbolize_names: true)[:data]

        expect(items.count).to eq(1)
        expect(items).to be_an(Array)
        expect(items.first).to have_key(:id)
        expect(items.first[:attributes]).to have_key(:name)
        expect(items.first[:attributes][:name]).to be_a(String)
      end
    end

    describe 'sad path' do
      it 'returns an array of data even if zero items are found' do

        get '/api/v1/items'

        expect(response.status).to eq(200)

        items = JSON.parse(response.body, symbolize_names: true)[:data]

        expect(items).to be_an(Array)
      end
    end
  end

  describe 'GET /api/v1/items/:id endpoint' do
    describe 'happy path' do
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
    end

    describe 'edge cases' do
      it 'returns a 404 status if the id is not valid' do
        id = create(:item).id

        get "/api/v1/items/#{id+1}"

        expect(response.status).to eq(404)

        get "/api/v1/items/one"

        expect(response.status).to eq(404)
      end
    end
  end

  describe 'POST /api/v1/items endpoint' do
    describe 'happy path' do
      it 'can create an item' do
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
    end
    
    describe 'sad path' do
      it 'returns an error if any attribute is missing' do
        id = create(:merchant).id
        item_params = {
          name: 'Schmidts Suede Pants',
          description: "I can't cure damaged suede",
          merchant_id: id
        }
        post '/api/v1/items', params: { item: item_params }, as: :json
        
        expect(response.status).to eq(200)

        error = JSON.parse(response.body, symbolize_names: true)[:data]
        
        expect(error[:errors].first).to eq("Unit price can't be blank")
      end
    end
  end

  describe 'edit an item endpoint' do
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
  end 

  describe 'delete an item endpoint' do
    it 'can delete an item' do
      item = create(:item)

      delete "/api/v1/items/#{item.id}"

      expect(response).to be_successful
      expect { Item.find(item.id) }.to raise_error(ActiveRecord::RecordNotFound)
    end
  end

  describe 'get all merchant data for a given item ID endpoint' do
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
  end 

  describe 'find all items based on search criteria endpoint' do
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
end
