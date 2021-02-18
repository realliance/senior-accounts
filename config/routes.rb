# frozen_string_literal: true

Rails.application.routes.draw do
  resource :user, only: %i[create update show]
  post :session, to: 'users#create_session'
  delete :session, to: 'users#destroy_session'
  get '/confirm/:email_confirmation_token', to: 'users#confirm_email', as: 'confirm_email'
  post '/password/recovery', to: 'users#password_recovery'
  get '/password/reset/:password_recovery_token', to: 'users#password_reset', as: 'password_reset'
  post '/password/reset/:password_recovery_token', to: 'users#password_update', as: 'password_update'
  resource :friends, only: %i[show create update destroy]
  post '/friends/invite', to: 'friends#invite'
  post '/friends/accept_invitation', to: 'friends#accept_invitation'
  post '/friends/kick', to: 'friends#kick'
  delete '/friends/disband', to: 'friends#disband'
end
