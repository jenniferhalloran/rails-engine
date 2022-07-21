# frozen_string_literal: true

class Merchant < ApplicationRecord
  has_many :items
  has_many :invoices
  has_many :invoice_items, through: :invoices 
  has_many :customers, through: :invoices
  has_many :transactions, through: :invoices

  def self.name_search_first(keyword)
    where('name ilike ?', "%#{keyword.downcase}%")
      .order(arel_table['name'].lower)
      .first
  end

  def self.name_search_all(keyword)
    where('name ilike ?', "%#{keyword.downcase}%")
      .order(arel_table['name'].lower)
  end

  def self.merchant_exists?(id)
    where(id: id).exists?
  end

  def self.top_merchants_by_revenue(quantity)
    joins(invoices: [:invoice_items, :transactions])
    .where(transactions: {result: 'success'}, invoices: {status: 'shipped'})
    .select(:name, :id, 'SUM(invoice_items.quantity * invoice_items.unit_price) as revenue')
    .group(:id)
    .order(revenue: :desc)
    .limit(quantity)
  end

  def self.top_merchants_by_item_count(quantity)
    joins(invoices: [:invoice_items, :transactions])
    .where(transactions: {result: 'success'}, invoices: {status: 'shipped'})
    .select(:name, :id, 'SUM(invoice_items.quantity) as item_count')
    .group(:id)
    .order(item_count: :desc)
    .limit(quantity)
  end

end
