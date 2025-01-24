require 'sidekiq/web'

Rails.application.routes.draw do

  resources :reminders

  root "reminders#index"
  mount ActionCable.server => '/cable'
  mount Sidekiq::Web => "/sidekiq"

end
