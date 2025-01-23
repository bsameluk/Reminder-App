require 'sidekiq/web'

Rails.application.routes.draw do

  resources :reminders, only: [:index, :new, :create, :destroy]

  root "reminders#index"
  mount ActionCable.server => '/cable'
  mount Sidekiq::Web => "/sidekiq"

end
