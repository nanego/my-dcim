Rails.application.routes.draw do
  resources :couple_baies
  resources :baies, only: [:edit, :update, :show] do
    collection do
      post :sort
    end
  end

  resources :ports, only: [:index, :edit, :update, :destroy]

  resources :clusters
  resources :slots
  resources :serveurs do
    collection do
      get :grid
      get :baies
      post :sort
    end
  end
  resources :serveurs_grids, only: [:index] do
    collection do
      get :reseau
    end
  end
  resources :actes
  resources :cards
  resources :colors
  resources :salles do
    collection do
      get :ilot
    end
  end
  resources :gestions
  resources :domaines
  resources :modeles
  resources :marques
  resources :architectures
  resources :categories
  resources :armoires
  resources :localisations
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
