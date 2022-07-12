# frozen_string_literal: true

module Api
  module V1
    module Items
      class SearchesController < ApplicationController
        def index
          match = Merchant.name_search(params[:name])

          render json: MerchantSerializer.new(match)
        end
      end
    end
  end
end
