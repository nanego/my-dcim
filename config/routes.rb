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
      get "/frames/:frame_id", to: "moves#frame", as: :frame
      get "/print/:frame_id", to: "moves#print", as: :print
      match 'update_connection', to: 'moves#update_connection', via: %i[patch post put]
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
  resources :server_states

  resources :frames do
    collection do
      post :sort
    end
    member do
      get :network
    end
  end

  resources :ports, except: %i[create]
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

    member do
      get :duplicate
      get :destroy_connections
    end
  end

  resources :servers_grids, only: [:index]
  resources :card_types
  resources :colors
  resources :rooms do
    collection do
      get :overview
    end
  end
  resources :bays
  resources :gestions
  resources :domaines
  resources :modeles do
    get :duplicate, on: :member
  end
  resources :manufacturers
  resources :architectures
  resources :categories

  resources :external_app_records, only: %i[index] do
    collection do
      get :settings
      put :settings
      put :sync_all_servers_with_glpi, as: :sync_with_glpi
    end
  end
  resources :external_app_requests, only: %i[show destroy]

  resources :contacts
  resources :contact_roles
  resources :contact_assignments

  namespace :visualization do
    resource :infrastructure, only: :show
    resource :network_capacity, only: :show
    resources :rooms, only: :show do
      get :print, on: :member
    end
    resources :frames, only: :show do
      get :print, on: :member
    end
    resources :bays, only: :show do
      get :print, on: :member
    end
  end

  root to: 'pages#index'
  get :about, to: 'pages#about'
  devise_for :users, controllers: { omniauth_callbacks: 'users/omniauth_callbacks',
                                    registrations: 'users/registrations',
                                    sessions: 'users/sessions' }

  namespace :bulk do
    resource :servers, only: :destroy
  end

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

  get 'search', to: 'search#index'

  resources :changelog_entries, only: %i[index show]
  get "/:object_type/:object_id/changelog_entries", to: "changelog_entries#index", as: :object_changelog_entries

  mount Lookbook::Engine, at: "/lookbook" if Rails.env.development?
end
