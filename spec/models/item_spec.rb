# frozen_string_literal: true

require 'rails_helper'

RSpec.describe Item, type: :model do
  describe 'class methods' do
    describe 'name_search_all(keyword)' do
      it 'returns all items with names that partially match the keyword' do
        item1 = create(:item, name: 'Backpack')
        item2 = create(:item, name: 'Hiking Boots')
        item3 = create(:item, name: 'Gumboot')
        item4 = create(:item, name: 'Tent')
        item5 = create(:item, name: 'Harness')
        expect(Item.name_search_all('BOOT')).to match_array([item2, item3])
      end
    end
  end
end
