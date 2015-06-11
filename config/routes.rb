Rails.application.routes.draw do
  devise_for :users
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
  get 'publications' => 'publications#index'
  get 'publications/:id' => 'publications#show', as: :publication

  devise_for :admin_users, ActiveAdmin::Devise.config
  ActiveAdmin.routes(self)
end
