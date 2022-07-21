# frozen_string_literal: true

require 'rails_helper'

RSpec.describe 'Merchant Items API' do
  describe 'GET /api/v1/merchants/:id/items endpoint' do
    describe 'happy path' do
      it 'gets all items for a given merchant ID' do
        id = create(:merchant).id
        create_list(:item, 4, merchant_id: id)

        get "/api/v1/merchants/#{id}/items"

        expect(response.status).to eq(200)

        items = JSON.parse(response.body, symbolize_names: true)[:data]

        expect(items.count).to eq(4)

        items.each do |item|
          expect(item[:attributes]).to include(:name, :description, :unit_price, :unit_price)
          expect(item[:attributes][:merchant_id]).to eq(id)
          expect(item[:attributes][:unit_price]).to be_a(Float)
          expect(item[:attributes][:name]).to be_a(String)
          expect(item[:attributes][:description]).to be_a(String)
        end
      end
    end
  end

  # describe 'sad path' do
  #   it 'returns a 404 if the merchant does not exist' do
  #     id = create(:merchant).id
  #     create_list(:item, 4, merchant_id: id)

  #     get "/api/v1/merchants/#{id+1.to_i}/items"
  #     require 'pry'; binding.pry
  #     expect(response.status).to eq(404)
  #   end
  # end
  #   end
  describe 'GET /api/v1/merchants/:id/items endpoint' do
    describe 'happy path' do
      it 'gets all merchants for a given item ID' do
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
  end
end
