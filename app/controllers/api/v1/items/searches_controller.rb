# frozen_string_literal: true

module Api
  module V1
    module Items
      class SearchesController < ApplicationController
        def index
          match = Merchant.name_search(params[:name])
          if match.nil?
            render json: {data: {errors: "No match was found."}}
          else
            render json: MerchantSerializer.new(match)
          end
        end
      end
    end
  end
end
