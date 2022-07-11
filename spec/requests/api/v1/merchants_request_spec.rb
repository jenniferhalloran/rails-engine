require 'rails_helper'

RSpec.describe "Merchants API" do
    it "sends a list of merchants" do
        create_list(:merchant, 3)

        get '/api/v1/merchants'
        
        expect(response).to be_successful
    
        merchants = JSON.parse(response.body, symbolize_names: true)[:data]

        expect(merchants.count).to eq(3)
                
        merchants.each do |merchant|
            expect(merchant[:attributes]).to include(:id, :name)
            expect(merchant[:attributes][:id]).to be_an(Integer)
            expect(merchant[:attributes][:name]).to be_a(String)
        end
    end

    it "can get one merchant by its id" do
        id = create(:merchant).id 
        get "/api/v1/merchants/#{id}"

        merchant = JSON.parse(response.body, symbolize_names: true)[:data]

        expect(response).to be_successful
    end
    
    
end