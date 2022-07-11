# frozen_string_literal: true

require 'rails_helper'

RSpec.describe 'Items API' do
    it 'sends a list of merchants' do
        id = create(:merchant).id
        create_list(:item, 3, merchant_id: id)

        get 'api/v1/items'

        expect(response).to be_successful
    end
end