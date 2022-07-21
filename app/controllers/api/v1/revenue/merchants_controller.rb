class Api::V1::Revenue::MerchantsController < ApplicationController
    def index
        if params[:quantity].nil?
            render json: {error: 'Bad Request'}, status: :bad_request
        else
            merchants = Merchant.top_merchants_by_revenue(params[:quantity])
            render json: MerchantNameRevenueSerializer.new(merchants)
        end 
    end
  end