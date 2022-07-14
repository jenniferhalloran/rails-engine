# frozen_string_literal: true

require 'rails_helper'

RSpec.describe Item, type: :model do
  describe 'relationships' do
    it { should belong_to :merchant }
    it { should have_many :invoice_items }
    it { should have_many(:invoices).through(:invoice_items) }
  end

  describe 'class methods' do
    describe 'name_search(keyword)' do
      it 'returns all items with names that partially match the keyword' do
        item1 = create(:item, name: 'Backpack')
        item2 = create(:item, name: 'Hiking Boots')
        item3 = create(:item, name: 'Gumboot')
        item4 = create(:item, name: 'Tent')
        item5 = create(:item, name: 'Harness')
        expect(Item.name_search('BOOT')).to match_array([item2, item3])
      end
    end

    describe 'item_exists?(id)' do
      it 'returns true if a item exists with the given id, and false if not' do
        item = create(:item)

        expect(Item.item_exists?(item.id)).to eq(true)
        expect(Item.item_exists?(item.id + 1)).to eq(false)
      end
    end
  end
end
