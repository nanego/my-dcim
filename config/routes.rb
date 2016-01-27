Rails.application.routes.draw do
  resources :serveurs
  resources :actes
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
  root to: 'pages#index'
  devise_for :users
  resources :users
end
