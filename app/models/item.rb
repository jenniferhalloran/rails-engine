# frozen_string_literal: true

class Item < ApplicationRecord
  belongs_to :merchant

  def self.name_search_all(keyword)
    where('LOWER(name) like ?', "%#{keyword.downcase}%")
  end
end
