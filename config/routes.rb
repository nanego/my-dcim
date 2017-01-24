Rails.application.routes.draw do
  resources :maintainers
  resources :contract_types
  resources :maintenance_contracts
  resources :server_states

  resources :frames, only: [:edit, :update, :show, :index, :destroy] do
    collection do
      post :sort
    end
  end

  resources :ports, only: [:index, :edit, :update, :destroy]

  resources :clusters
  resources :slots
  resources :servers do
    collection do
      get :grid
      get :frames
      post :sort
      get :import_csv
      post :import
    end
  end
  resources :servers_grids, only: [:index] do
    collection do
      get :reseau
    end
  end
  resources :actes
  resources :cards
  resources :colors
  resources :rooms do
    collection do
      get :islet
      get :overview
    end
  end
  resources :bays
  resources :gestions
  resources :domaines
  resources :modeles
  resources :marques
  resources :architectures
  resources :categories
  namespace :admin do
    DashboardManifest::DASHBOARDS.each do |dashboard_resource|
      resources dashboard_resource
    end
    root controller: DashboardManifest::ROOT_DASHBOARD, action: :index
  end
  root to: 'pages#index'
  devise_for :users, controllers: { omniauth_callbacks: "users/omniauth_callbacks", :registrations => "users/registrations" }
  resources :users

  resources :connections

  resources :activities
end
