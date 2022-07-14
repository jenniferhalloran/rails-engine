# frozen_string_literal: true

require 'rails_helper'

RSpec.describe Item, type: :model do
  describe 'relationships' do
    it { should belong_to :merchant }
    it { should have_many :invoice_items }
    it { should have_many(:invoices).through(:invoice_items) }
  end

  describe 'validations' do
    it { should validate_presence_of(:name) }
    it { should validate_presence_of(:description) }
    it { should validate_presence_of(:unit_price) }
    it { should validate_numericality_of(:unit_price) }
  end

  describe 'class methods' do
    describe 'name_search(keyword, limit)' do
      it 'returns all items with names that partially match the keyword' do
        item1 = create(:item, name: 'Backpack', unit_price: 40.99)
        item2 = create(:item, name: 'Hiking Boots', unit_price: 35.99)
        item3 = create(:item, name: 'Gumboot', unit_price: 19.99)
        item4 = create(:item, name: 'Tent', unit_price: 99.99)
        item5 = create(:item, name: 'Harness', unit_price: 24.99)

        expect(Item.name_search('BOOT')).to match_array([item2, item3])
      end

      it 'returns the first item with a name that partially match the keyword' do
        item1 = create(:item, name: 'Backpack', unit_price: 40.99)
        item2 = create(:item, name: 'Hiking Boots', unit_price: 35.99)
        item3 = create(:item, name: 'Gumboot', unit_price: 19.99)
        item4 = create(:item, name: 'Tent', unit_price: 99.99)
        item5 = create(:item, name: 'Harness', unit_price: 24.99)

        expect(Item.name_search('BOOT', 1)).to eq([item2])
      end
    end

    describe 'price_search(limit, min_price: "0", max_price: nil)' do
      before do
        @item1 = create(:item, name: 'Backpack', unit_price: 40.99)
        @item2 = create(:item, name: 'Hiking Boots', unit_price: 35.99)
        @item3 = create(:item, name: 'Gumboot', unit_price: 19.99)
        @item4 = create(:item, name: 'Tent', unit_price: 99.99)
        @item5 = create(:item, name: 'Harness', unit_price: 24.99)
      end
      it 'returns all items with a price greater than a given unit_price' do
        max_price = nil
        limit = nil

        expect(Item.price_search(limit, 40, max_price)).to match_array([@item1, @item4])
      end

      it 'returns all items with a price less than than a given unit_price' do
        min_price = nil
        limit = nil

        expect(Item.price_search(limit, min_price, 40)).to match_array([@item2, @item3, @item5])
      end

      it 'returns all items with a price less than than a given unit_price and more than a given unit price' do
        limit = nil

        expect(Item.price_search(limit, 20, 45)).to match_array([@item5, @item1, @item2])
      end

      it 'returns one item with a price less than than a given unit_price and more than a given unit price' do
        limit = 1

        expect(Item.price_search(limit, 20, 45)).to eq([@item1])
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
