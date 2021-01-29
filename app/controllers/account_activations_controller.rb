# frozen_string_literal: true

class AccountActivationsController < ApplicationController
  skip_before_action :check_token, only: %i[edit]

  def edit
    @user = User.find_by(email: params[:email])
    if @user && !@user.activated
      @user.update(activated: true)
      render json: { success: 'Email confirmed successfully' }
    else
      render json: { error: 'Failed to confirm email' }
    end
  end
end
