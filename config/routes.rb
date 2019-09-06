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

  concern :offertable do
    resources :offers
  end

  concern :orderable do
    resources :orders
  end

  concern :tenderable do
    resources :tenders
    resources :tender_lines
  end

  concern :productable do
    resources :products
    resources :packagings
    resources :aspects
    resources :sizes
    resources :varieties
    get 'products/get_names', to: 'products#get_names', as: :products_get_names
  end

  resources :brokers
  authenticated :broker do
    resources :offers
    resources :packagings
    resources :aspects
    resources :sizes
    resources :varieties
    get 'products/get_names', to: 'products#get_names', as: :products_get_names
    resources :products
    resources :orders
    resources :tenders
    resources :tender_lines
  end

  resources :suppliers, concerns: [:offertable, :orderable, :productable, :tenderable] do
    member do
      get 'attach_products', as: :attach_products
      post 'attach_products_create', as: :attach_products_create
      post 'detach_product', as: :detach_product
    end
  end

  resources :customers, concerns: [:offertable, :orderable, :tenderable, :productable] do
    member do
      get 'attach_products', as: :attach_products
      post 'attach_products_create', as: :attach_products_create
      post 'detach_product', as: :detach_product
    end
  end
  authenticate :broker do
    mount Sidekiq::Web => '/sidekiq'
  end
end
