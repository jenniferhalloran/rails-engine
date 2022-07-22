# frozen_string_literal: true

class InvoiceItem < ApplicationRecord
  belongs_to :item
  belongs_to :invoice

  def self.total_revenue_during(start, end)
    start_date = Time.zone.parse(start)
    end_date = Time.zone.parse(end)
    InvoiceItem.joins(:transaction)
    .where(transactions: {result: 'success', created_at: start_date..end_date})
    .sum('quantity*unit_price')
  end
end
