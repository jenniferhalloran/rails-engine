# frozen_string_literal: true

class Merchant < ApplicationRecord
  has_many :items

  def self.name_search_first(keyword)
    where('LOWER(name) like ?', "%#{keyword.downcase}%")
      .order('LOWER(name)')
      .first
  end
end
