# frozen_string_literal: true

class Merchant < ApplicationRecord
  has_many :items

  def self.name_search_first(keyword)
    where('name ilike ?', "%#{keyword.downcase}%")
      .order(arel_table['name'].lower)
      # .order('LOWER(name)')   --> avoid deprecation warning
      .first
  end

  def self.merchant_exists?(id)
    where(id: id).exists?
  end
end
