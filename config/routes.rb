# frozen_string_literal: true

Rails.application.routes.draw do
  root 'flights#index'
  get '/:id', to: 'flights#index'
  resources :bookings, only: %i[new index create show]
end
