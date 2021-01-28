# frozen_string_literal: true

Rails.application.routes.draw do
  resource :user, only: %i[create update show]
  post :session, to: 'users#create_session'
  delete :session, to: 'users#destroy_session'
end
