# frozen_string_literal: true

module Api
  module V1
    module Merchants
      class SearchesController < ApplicationController
        def show
          match = Merchant.name_search_first(params[:name])
          if match.nil?
            render json: { data: { errors: 'No match was found.' } }
          else
            render json: MerchantSerializer.new(match)
          end
        end
      end
    end
  end
end
