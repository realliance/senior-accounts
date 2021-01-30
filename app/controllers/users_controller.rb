# frozen_string_literal: true

class UsersController < ApplicationController
  skip_before_action :check_token, only: %i[create confirm_email create_session]

  def create
    @user = User.create(create_params)
    if @user.save
      render status: :created, action: :show
      UserMailer.email_confirmation(@user, @user.email).deliver_now
    else
      render status: :bad_request, json: @user.errors
    end
  end

  def confirm_email
    @user = User.find_by(email_confirmation_token: params[:email_confirmation_token])
    if @user && !@user.activated
      @user.update(activated: true)
      render status: :ok, json: { success: 'Email confirmed successfully' }
    elsif @user
      @user.update(email: @user.unconfirmed_email, unconfirmed_email: nil)
      render status: :ok, json: { success: 'Email updated successfully' }
    else
      render status: :bad_request, json: { error: 'Invalid request' }
    end
  end

  def show
    @user = current_user
  end

  def update
    @user = current_user
    if @user.update(update_params)
      render :show
      if params[:unconfirmed_email].present?
        @user.regenerate_email_confirmation_token
        UserMailer.email_confirmation(@user, @user.unconfirmed_email).deliver_now
      end
    else
      render status: :bad_request, json: current_user.errors
    end
  end

  def create_session
    @user = User.find_by(email: params[:email])
    if @user&.authenticate(params[:password]) && @user&.activated
      render status: :ok, json: { token: @user.auth_token }
    elsif @user&.authenticate(params[:password])
      render status: :bad_request, json: { error: 'Please activate your account by following the instructions in the account confirmation email you received to proceed.' }
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
    params.require(:user).permit(:unconfirmed_email, :password)
  end
end
