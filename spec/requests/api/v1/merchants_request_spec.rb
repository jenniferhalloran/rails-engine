# frozen_string_literal: true

require 'rails_helper'

RSpec.describe 'Merchants API' do
  it 'sends a list of merchants' do
    create_list(:merchant, 3)

    get '/api/v1/merchants'

    expect(response.status).to eq(200)

    merchants = JSON.parse(response.body, symbolize_names: true)[:data]

    expect(merchants.count).to eq(3)

    merchants.each do |merchant|
      expect(merchant).to have_key(:id)

      expect(merchant[:attributes]).to have_key(:name)
      expect(merchant[:attributes][:name]).to be_a(String)
    end
  end

  it 'can return one merchant by its id' do
    id = create(:merchant).id
    get "/api/v1/merchants/#{id}"

    expect(response.status).to eq(200)

    merchant = JSON.parse(response.body, symbolize_names: true)[:data]

    expect(merchant).to have_key(:id)

    expect(merchant[:attributes]).to have_key(:name)
    expect(merchant[:attributes][:name]).to be_a(String)
  end

  # #Sad path??

  it 'returns all items for a given merchant id' do
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

  it 'returns a single merchant that matches a seach term' do
    create(:merchant, name: 'Lands End')
    create(:merchant, name: 'Crate And Barrel')
    create(:merchant, name: 'REI')
    create(:merchant, name: 'Patagonia')

    get '/api/v1/merchants/find?name=And'

    expect(response.status).to eq(200)

    result = JSON.parse(response.body, symbolize_names: true)[:data]

    expect(result).to have_key(:id)

    expect(result[:attributes]).to have_key(:name)
    expect(result[:attributes][:name]).to eq('Crate And Barrel')
    expect(result[:attributes][:name]).to_not eq('Lands End')
  end

  it 'does not return a 404 error if there are no matches' do
    create(:merchant, name: 'Lands End')
    create(:merchant, name: 'Crate And Barrel')
    create(:merchant, name: 'REI')
    create(:merchant, name: 'Patagonia')

    get '/api/v1/merchants/find?name=cats'

    expect(response.status).to eq(200)

    result = JSON.parse(response.body, symbolize_names: true)
    expect(result).to have_key(:data)
    expect(result[:data][:errors]).to eq('No match was found.')
  end
end
