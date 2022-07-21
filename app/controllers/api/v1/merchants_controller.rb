# frozen_string_literal: true

class Api::V1::MerchantsController < ApplicationController
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

  def most_items
    if params[:quantity].nil?
      render json: {error: 'Bad Request'}, status: :bad_request
    else
        merchants = Merchant.top_merchants_by_item_count(params[:quantity])
        render json: MerchantItemCountSerializer.new(merchants)
    end 
  end
end
