# frozen_string_literal: true

module Api
  module V1
    module Items
      class SearchesController < ApplicationController

        def index
          if bad_request?
            render json: {data: [], error: "Bad request"}, status: :bad_request
          else
            matches = search_all_items
            if matches == []
              render json: { data: [], error: "No matches  Found"}
            else
              render json: ItemSerializer.new(matches)
            end
          end
        end

        private 

        def search_all_items 
          return Item.name_search_all(params[:name]) if params[:name]
          return Item.price_search_all(min_price: params[:min_price], max_price: params[:max_price]) if params[:min_price] || params[:max_price]
        end

        def bad_request?
          params[:name] && (params[:min_price] || params[:max_price])
        end
      end
    end
  end
end
