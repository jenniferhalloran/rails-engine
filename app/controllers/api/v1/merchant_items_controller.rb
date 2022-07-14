# frozen_string_literal: true

module Api
  module V1
    class MerchantItemsController < ApplicationController
      def index
        merchant = Merchant.find(params[:merchant_id])

        render json: ItemSerializer.new(merchant.items)
      end

      def show
        item = Item.find(params[:id])

        render json: MerchantSerializer.new(item.merchant)
      end
    end
  end
end

# def index
#   if Merchant.merchant_exists?(params[:merchant_id])
#     merchant = Merchant.find(params[:merchant_id])
#     render json: ItemSerializer.new(merchant.items)
#   else
#     render status: 404
#   end
# end
