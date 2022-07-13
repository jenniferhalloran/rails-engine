# frozen_string_literal: true

require 'rails_helper'

RSpec.describe Merchant, type: :model do
  describe 'relationships' do
      it { should have_many :items}
  end

  describe 'class methods' do
    describe 'name_search_first(keyword)' do
      it 'returns the first matching merchant in case insensitive order' do
        merchant1 = create(:merchant, name: 'Lands End')
        merchant2 = create(:merchant, name: 'Crate And Barrel')
        merchant3 = create(:merchant, name: 'REI')
        merchant4 = create(:merchant, name: 'Patagonia')
        expect(Merchant.name_search_first('and')).to eq(merchant2)
      end
    end
  end
end
