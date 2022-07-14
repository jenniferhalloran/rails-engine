# frozen_string_literal: true

class Api::V1::Items::SearchesController < ApplicationController
  def index
    render_404 if bad_request?
    if search_items == []
      render json: { data: [], error: 'No matches found' }
    else
      render json: ItemSerializer.new(search_items)
    end
  end

  def show
    if bad_request?
      render json: { data: [], error: 'Bad request' }, status: :bad_request
    else
      if search_items(1) == []
        render json: { data: { error: 'Item not found' } }
      else
        render json: ItemSerializer.new(search_items(1).first)
      end
    end
  end

  private

  def search_items(limit = nil)
    return Item.name_search(params[:name], limit) if params[:name]

    if params[:min_price] || params[:max_price]
      Item.price_search(limit, params[:min_price],
                        params[:max_price])
    end
  end

  def bad_request?
    return true if params[:name] && (params[:min_price] || params[:max_price])
    return true if params[:max_price] && params[:max_price].to_i < 0
    return true if params[:min_price] && params[:min_price].to_i < 0
  end

  def render_404
    render json: { data: [], error: 'Bad request' }, status: :bad_request
    exit
  end
end
