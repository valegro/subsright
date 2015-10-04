Rails.application.routes.draw do
  devise_for :users, controllers: { confirmations: 'confirmations' }
  devise_scope :user do
    patch '/users/confirmation' => 'confirmations#confirm'
  end

  resources :customers
  root 'welcome#index'

  get 'campaigns' => 'campaigns#index'
  get 'campaigns/:id' => 'campaigns#show', as: :campaign
  get 'discounts' => 'discounts#index'
  get 'offers' => 'offers#index'
  get 'offers/:id' => 'offers#show', as: :offer
  post 'offers/:id/purchases' => 'offers#purchase', as: :offer_purchases
  get 'prices' => 'prices#index'
  get 'products' => 'products#index'
  get 'products/:id' => 'products#show', as: :product
  get 'profile' => 'users#show'
  patch 'profile' => 'users#update'
  get 'profile/edit' => 'users#edit'
  get 'publications' => 'publications#index'
  get 'publications/:id' => 'publications#show', as: :publication

  devise_for :admin_users, ActiveAdmin::Devise.config
  ActiveAdmin.routes(self)

  namespace :api, defaults: { format: :json } do
    get 'version' => 'api#version'
    namespace :v1 do
      get 'subscribers' => 'subscribers#index'
      get 'subscribers/:id' => 'subscribers#show'
    end
  end
end
