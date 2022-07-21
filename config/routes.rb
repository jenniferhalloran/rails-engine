# frozen_string_literal: true

Rails.application.routes.draw do
  # For details on the DSL available within this file, see http://guides.rubyonrails.org/routing.html

  get '/api/v1/merchants/find', to: 'api/v1/merchants/searches#show'
  get '/api/v1/merchants/find_all', to: 'api/v1/merchants/searches#index'

  get '/api/v1/items/find_all', to: 'api/v1/items/searches#index'
  get '/api/v1/items/find', to: 'api/v1/items/searches#show'

  get '/api/v1/items/:id/merchant', to: 'api/v1/merchant_items#show'

  get '/api/v1/merchants/most_items', to: 'api/v1/merchants#most_items'

  namespace :api do
    namespace :v1 do
      resources :items, only: %i[index show create update destroy]

      resources :merchants, only: %i[index show] do
        resources :items, only: %i[index], controller: :merchant_items
      end

      namespace :revenue do 
        resources :merchants, only: [:index]
      end

    end
  end
end
