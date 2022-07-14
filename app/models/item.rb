# frozen_string_literal: true

class Item < ApplicationRecord
  belongs_to :merchant
  has_many :invoice_items, dependent: :destroy
  has_many :invoices, through: :invoice_items

  validates_presence_of :name, :description, :unit_price
  validates_numericality_of :unit_price

  def self.name_search(keyword, limit = nil)
    where('name ilike ?', "%#{keyword.downcase}%")
      .limit(limit)
  end

  def self.price_search(limit, min_price = '0', max_price = nil)
    max_price = Item.maximum(:unit_price).to_s if max_price.nil?
    where("unit_price >= #{min_price.to_f} AND unit_price <= #{max_price.to_f}")
      .limit(limit)
      .order(:name)
  end

  def self.item_exists?(id)
    where(id: id).exists?
  end

  def delete_single_invoices
    invoices.map { |invoice| invoice.destroy if invoice.items.count == 1 }
  end
end
