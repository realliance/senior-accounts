# frozen_string_literal: true

class UsersController < ApplicationController
  skip_before_action :check_token, only: %i[create activate create_session]

  def create
    @user = User.create(create_params)
    if @user.save
      render status: :created, action: :show
      UserMailer.account_activation(@user).deliver_now
    else
      render status: :bad_request, json: @user.errors
    end
  end

  def activate
    @user = User.find_by(email_confirmation_token: params[:email_confirmation_token])
    if @user && !@user.activated
      @user.update(activated: true)
      render json: { success: 'Email confirmed successfully' }
    else
      render json: { error: 'Failed to confirm email' }
    end
  end

  def show
    @user = current_user
  end

  def update
    @user = current_user
    if @user.update(update_params)
      render :show
    else
      render status: :bad_request, json: current_user.errors
    end
  end

  def create_session
    @user = User.find_by(email: params[:email])
    if @user&.authenticate(params[:password]) && @user&.activated
      render json: { token: @user.auth_token }
    elsif @user&.authenticate(params[:password])
      render json: { error: 'Please activate your account by following the instructions in the account confirmation email you received to proceed.' }
    else
      head :bad_request
    end
  end

  def destroy_session
    current_user.regenerate_auth_token
    head :ok
  end

  private

  def create_params
    params.require(:user).permit(:email, :username, :password)
  end

  def update_params
    params.require(:user).permit(:password)
  end
end
