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
  resources :offers, only: [:index, :show]

  concern :productable do
    resources :products
    resources :attached_products
  end

  concern :user_productable do
    resources :user_products, only: [:index, :update]
  end

  authenticated :broker do
    resources :suppliers
    resources :customers
    resources :brokers, concerns: [:productable] do
      resources :offers, controller: 'broker_offers'
      resources :orders, controller: 'broker_orders'
      resources :customers, concerns: [:productable, :user_productable] do
        resources :orders, controller: 'broker_orders'
      end
      resources :suppliers, concerns: [:productable, :user_productable] do
        resources :offers, controller: 'broker_offers'
      end
      resources :brokers
    end
    mount Sidekiq::Web => '/sidekiq'
  end

  authenticated :supplier do
    resources :suppliers, concerns: [:productable, :user_productable] do
      resources :suppliers
      resources :offers
      resources :orders, only: [:index, :show]
    end
  end

  authenticated :customer do
    resources :customers, concerns: [:productable, :user_productable] do
      resources :offers, only: [:index, :show]
      resources :orders
    end
  end
end
