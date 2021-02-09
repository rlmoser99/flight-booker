# frozen_string_literal: true

Rails.application.routes.draw do
  root 'flights#index'
  get '/:id', to: 'flights#index'
end
