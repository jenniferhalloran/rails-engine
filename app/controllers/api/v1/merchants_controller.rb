# frozen_string_literal: true

module Api
  module V1
    class MerchantsController < ApplicationController
      def index
        render json: MerchantSerializer.new(Merchant.all)
      end

      def show
        if Merchant.merchant_exists?(params[:id])
          render json: MerchantSerializer.new(Merchant.find(params[:id]))
        else
          render status: 404
        end
      end
    end
  end
end
