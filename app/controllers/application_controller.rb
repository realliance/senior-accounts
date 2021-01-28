# frozen_string_literal: true

class ApplicationController < ActionController::API
  include ActionController::HttpAuthentication::Token::ControllerMethods

  before_action :check_token
  helper_method :current_user

  private

  def check_token
    @current_user = authenticate_or_request_with_http_token do |token|
      User.find_by(auth_token: token)
    end
  end

  attr_reader :current_user
end
