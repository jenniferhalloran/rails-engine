# frozen_string_literal: true

module Api
  module V1
    module Items
      class SearchesController < ApplicationController
        def index
          matches = Item.name_search_all(params[:name])

          if matches == []
            render json: { data: [] }
          else
            render json: ItemSerializer.new(matches)
          end
        end
      end
    end
  end
end
