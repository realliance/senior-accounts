# frozen_string_literal: true

Rails.application.routes.draw do
  resource :user, only: %i[create update show]
end
