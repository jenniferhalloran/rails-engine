# frozen_string_literal: true

class Item < ApplicationRecord
  belongs_to :merchant
  has_many :invoice_items, dependent: :destroy
  has_many :invoices, through: :invoice_items

  validates_presence_of :name, :description, :unit_price

  def self.name_search_all(keyword)
    where('name ilike ?', "%#{keyword.downcase}%")
  end

  def self.item_exists?(id)
    where(id: id).exists?
  end

  def delete_single_invoices
    invoices.map { |invoice| invoice.destroy if invoice.items.count == 1 }
  end
end
