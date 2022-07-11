# frozen_string_literal: true

module Api
  module V1
    class ItemsController < ApplicationController
      def index
        # require 'pry'; binding.pry
        # merchant = Merchant.find(params[:id])

        # render json: ItemSerializer.new(merchant.items)
      end
    end
  end
end
