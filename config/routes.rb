require 'sidekiq/web'
Rails.application.routes.draw do
  root 'welcome#home'

  devise_for :suppliers, controllers: {
    registrations: 'suppliers/registrations',
    sessions: 'suppliers/sessions'
  }
  devise_for :brokers, controllers: {
    sessions: 'brokers/sessions'
  }
  devise_for :customers, controllers: {
    registrations: 'customers/registrations',
    sessions: 'customers/sessions'
  }

  resources :products, only: [:index, :show]
  resources :offers, only: [:index, :show], constraints: {id: /[0-9]*/}
  resources :requests, only: [:index, :show], constraints: {id: /[0-9]*/}

  concern :concrete_productable do
    resources :concrete_products, only: [:index, :new, :create, :destroy]
  end

  concern :user_productable do
    resources :user_products, only: [:index, :update]
  end

  authenticated :broker do
    resources :suppliers
    resources :customers
    resources :brokers, concerns: [:concrete_productable] do
      resources :products, constraints: {id: /[0-9]*/}
      resources :offers, controller: 'broker_offers'
      resources :orders, controller: 'broker_orders'
      resources :requests, controller: 'broker_requests'
      resources :responses, controller: 'broker_responses'
      resources :customers, concerns: [:concrete_productable, :user_productable] do
        resources :orders, controller: 'broker_orders'
        resources :requests, controller: 'broker_requests'
      end
      resources :suppliers, concerns: [:concrete_productable, :user_productable] do
        resources :offers, controller: 'broker_offers'
        resources :responses, controller: 'broker_responses'
      end
      resources :brokers
    end
    mount Sidekiq::Web => '/sidekiq'
  end

  authenticated :supplier do
    resources :suppliers, concerns: [:concrete_productable, :user_productable] do
      resources :suppliers
      resources :offers
      resources :orders, only: [:index, :show]
      resources :requests, only: [:index, :show]
      resources :responses
    end
  end

  authenticated :customer do
    resources :customers, concerns: [:concrete_productable, :user_productable] do
      resources :offers, only: [:index, :show]
      resources :orders
      resources :requests
      resources :responses, only: [:index, :show]
    end
  end
  match "/(*url)", to: 'welcome#routing_error', via: :all
end
