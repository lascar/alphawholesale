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

  concern :attached_productable do
    resources :attached_products
  end

  concern :user_productable do
    resources :user_products, only: [:index, :update]
  end

  authenticated :broker do
    resources :suppliers
    resources :customers
    resources :brokers, concerns: [:attached_productable] do
      resources :products, constraints: {id: /[0-9]*/}
      resources :offers, controller: 'broker_offers'
      resources :orders, controller: 'broker_orders'
      resources :customers, concerns: [:attached_productable, :user_productable] do
        resources :orders, controller: 'broker_orders'
      end
      resources :suppliers, concerns: [:attached_productable, :user_productable] do
        resources :offers, controller: 'broker_offers'
      end
      resources :brokers
    end
    mount Sidekiq::Web => '/sidekiq'
  end

  authenticated :supplier do
    resources :suppliers, concerns: [:attached_productable, :user_productable] do
      resources :suppliers
      resources :offers
      resources :orders, only: [:index, :show]
    end
  end

  authenticated :customer do
    resources :customers, concerns: [:attached_productable, :user_productable] do
      resources :offers, only: [:index, :show]
      resources :orders
    end
  end
  match "/(*url)", to: 'welcome#routing_error', via: :all
end
