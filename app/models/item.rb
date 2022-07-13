# frozen_string_literal: true

class Item < ApplicationRecord
  belongs_to :merchant

  def self.name_search_all(keyword)
    where('name ilike ?', "%#{keyword.downcase}%")
  end
end
