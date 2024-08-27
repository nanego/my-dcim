# frozen_string_literal: true

Rails.application.routes.draw do
  resources :air_conditioners
  resources :documents
  resources :moves do
    member do
      get :execute, to: 'moves#execute_movement'
    end
    collection do
      get :load_server
      get :load_frame
      get :load_connection
      get "/frames/:frame_id", to: "moves#frame"
      get "/print/:frame_id", to: "moves#print", as: :print
      match 'update_connection', to: 'moves#update_connection', via: [:patch, :post, :put]
    end
  end
  get 'data_import', action: 'index', controller: 'data_import'
  post 'data_import/ansible'

  resources :sites
  resources :islets do
    get :print, on: :member
  end
  resources :disk_types
  resources :memory_types
  resources :memory_components
  resources :disks
  resources :maintainers
  resources :contract_types
  resources :maintenance_contracts
  resources :server_states

  resources :frames do
    collection do
      post :sort
    end
    member do
      get :network
      get :print
    end
  end

  resources :ports, except: %i[create]
  get 'connections', to: "connections#index"
  get 'connections/edit', :action => 'edit', controller: 'connections'
  post 'connections/update_destination_server', :action => 'update_destination_server', controller: 'connections'
  post 'connections/update', :action => 'update', controller: 'connections'
  get 'connections/draw', :action => 'draw', controller: 'connections', as: :draw_connections
  resources :cables, only: %i[index destroy]
  resources :port_types

  resources :clusters
  resources :stacks
  resources :servers do
    collection do
      get :grid
      post :sort
      get :import_csv
      post :import
    end

    get :duplicate, on: :member
  end

  resources :servers_grids, only: [:index]
  resources :card_types
  resources :colors
  resources :rooms do
    collection do
      get :overview
    end

    get :print, on: :member
  end
  resources :bays do
    get :print, on: :member
  end
  resources :gestions
  resources :domaines
  resources :modeles
  resources :manufacturers
  resources :architectures
  resources :categories

  resources :external_app_records, only: %i[index] do
    collection do
      put :sync_all_servers_with_glpi, as: :sync_with_glpi
    end
  end
  resources :external_app_requests, only: %i[show destroy]

  namespace :visualization do
    resource :infrastructure, only: :show
    resource :network_capacity, only: :show
  end

  root to: 'pages#index'
  get :about, to: 'pages#about'
  devise_for :users, controllers: { omniauth_callbacks: 'users/omniauth_callbacks',
                                    registrations: 'users/registrations',
                                    sessions: 'users/sessions' }

  namespace :users do
    resource :settings, only: %i[edit update]
  end

  resources :users do
    collection do
      post :add_user
    end

    get :reset_authentication_token, on: :member
    patch :suspend, on: :member
    patch :unsuspend, on: :member
  end

  resources :activities
  resources :changelog_entries, only: %i[index show]
  get "/:object_type/:object_id/changelog_entries", to: "changelog_entries#index"

  mount Lookbook::Engine, at: "/lookbook" if Rails.env.development?
end
