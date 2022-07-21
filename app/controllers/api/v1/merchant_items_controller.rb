# frozen_string_literal: true

class Api::V1::MerchantItemsController < ApplicationController
  def index
    merchant = Merchant.find(params[:merchant_id])
    render json: ItemSerializer.new(merchant.items)
  end

  def show
    item = Item.find(params[:id])
    render json: MerchantSerializer.new(item.merchant)
  end
end
