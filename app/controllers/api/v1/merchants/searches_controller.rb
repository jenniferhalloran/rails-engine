# frozen_string_literal: true

class Api::V1::Merchants::SearchesController < ApplicationController
  def show
    match = Merchant.name_search_first(params[:name])
    if match.nil?
      render json: { data: { errors: 'No match was found.' } }
    else
      render json: MerchantSerializer.new(match)
    end
  end

  def index
    matches = Merchant.name_search_all(params[:name])
    # if matches.nil?
    #   render json: { data: { errors: 'No match was found.' } }
    # else
      render json: MerchantSerializer.new(matches)
    # end
  end
end
