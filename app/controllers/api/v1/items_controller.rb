# frozen_string_literal: true

module Api
  module V1
    class ItemsController < ApplicationController
      def index
        merchant = Merchant.find(params[:merchant_id])

        render json: ItemSerializer.new(merchant.items)
      end
    end
  end
end
