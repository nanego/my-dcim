Rails.application.routes.draw do
  resources :baies, only: [:edit, :update] do
    collection do
      post :sort
    end
  end

  resources :clusters
  resources :slots
  resources :serveurs do
    collection do
      get :grid
      get :baies
      get :baie
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
  resources :salles
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
  root to: 'serveurs#index'
  devise_for :users
  resources :users

  resources :connections
end
