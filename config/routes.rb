# frozen_string_literal: true

Rails.application.routes.draw do
  root 'bookings#new'
  get '/:id', to: 'flights#index'
  resources :bookings, only: %i[new index create show]
end
