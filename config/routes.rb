Rails.application.routes.draw do

  root 'welcome#index'

  get 'campaigns' => 'campaigns#index'
  get 'campaigns/:id' => 'campaigns#show', as: :campaign
  get 'offers' => 'offers#index'
  get 'offers/:id' => 'offers#show', as: :offer
  get 'products' => 'products#index'
  get 'products/:id' => 'products#show', as: :product

  devise_for :admin_users, ActiveAdmin::Devise.config
  ActiveAdmin.routes(self)

end
