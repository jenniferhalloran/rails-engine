# frozen_string_literal: true

class Item < ApplicationRecord
  belongs_to :merchant
  has_many :invoice_items
  has_many :invoices, through: :invoice_items

  def self.name_search_all(keyword)
    where('name ilike ?', "%#{keyword.downcase}%")
  end
end
