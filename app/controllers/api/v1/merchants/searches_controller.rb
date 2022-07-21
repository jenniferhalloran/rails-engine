# frozen_string_literal: true

class Api::V1::Merchants::SearchesController < ApplicationController
  def show
    if bad_request?
      render json: { error: 'Bad Request' }, status: :bad_request
    else
      match = Merchant.name_search_first(params[:name])
      if match.nil?
        render json: { data: { errors: 'No match was found.' } }
      else
        render json: MerchantSerializer.new(match)
      end
    end
  end

  def index
    if bad_request?
      render json: { error: 'Bad Request' }, status: :bad_request
    else
      matches = Merchant.name_search_all(params[:name])
      render json: MerchantSerializer.new(matches)
    end
  end

  private

  def bad_request?
    params[:name].nil? || params[:name].empty?
  end
end
