# frozen_string_literal: true

class ApplicationController < ActionController::API
  include ActionController::HttpAuthentication::Token::ControllerMethods
  include ActionView::Layouts

  before_action :check_token
  helper_method :current_user

  private

  def check_token
    @current_user = authenticate_with_http_token do |token|
      User.find_by(auth_token: token)
    end
    if @current_user.nil?
      request_http_token_authentication
    else
      Sentry.set_user(id: @current_user.id, username: @current_user.username, email: @current_user.email)
    end
  end

  attr_reader :current_user
end
