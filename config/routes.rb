# frozen_string_literal: true

Rails.application.routes.draw do
  # For details on the DSL available within this file, see http://guides.rubyonrails.org/routing.html

  get '/api/v1/merchants/find', to: 'api/v1/items/searches#index'
  get '/api/v1/items/:id/merchant', to: 'api/v1/merchant_items#show'

  namespace :api do
    namespace :v1 do
      resources :items, only: %i[index show create update destroy]
      resources :merchants, only: %i[index show] do
        resources :items, only: %i[index], controller: :merchant_items
      end
    end
  end
end
