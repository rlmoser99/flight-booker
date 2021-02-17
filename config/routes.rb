# frozen_string_literal: true

Rails.application.routes.draw do
  root 'flights#index'
  get '/:id', to: 'flights#index'
  resources :passengers
  resources :bookings do
    resources :tickets
  end
end
