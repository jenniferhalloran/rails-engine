# frozen_string_literal: true

module Api
  module V1
    module Items
      class SearchesController < ApplicationController

        def index
          if bad_request?
            render json: {data: [], error: "Bad request"}, status: :bad_request
          else
            matches = search_items
            if matches == []
              render json: { data: [], error: "No matches found"}
            else
              render json: ItemSerializer.new(matches)
            end
          end
        end

        def show
          if bad_request?
            render json: {data: [], error: "Bad request"}, status: :bad_request
          else
            match = search_items(1)
            if match == []
              render json: {data: {error: 'Item not found'}}
            else
              render json: ItemSerializer.new(match.first)
            end
          end
        end

        private 

        def search_items(limit = nil)
          return Item.name_search(params[:name], limit) if params[:name]
          return Item.price_search(min_price: params[:min_price], max_price: params[:max_price]) if params[:min_price] || params[:max_price]
        end

        def bad_request?
          params[:name] && (params[:min_price] || params[:max_price])
        end
      end
    end
  end
end
