# frozen_string_literal: true

class UsersController < ApplicationController
  skip_before_action :check_token, only: %i[create confirm_email create_session password_recovery password_reset]

  def show
    @user = current_user
  end

  def create
    @user = User.create(user_params)
    if @user.save
      render status: :created, action: :show
    else
      @user.errors.add(:email, @user.errors.delete(:unconfirmed_email)) if @user.errors.include?(:unconfirmed_email)
      render status: :bad_request, json: @user.errors
    end
  end

  def update
    @user = current_user
    if @user.update(user_params)
      render status: :ok, action: :show
    else
      @user.errors.add(:email, @user.errors.delete(:unconfirmed_email)) if @user.errors.include?(:unconfirmed_email)
      render status: :bad_request, json: @user.errors
    end
  end

  def confirm_email
    @user = User.find_by(email_confirmation_token: params[:email_confirmation_token])
    if @user&.update(email: @user.unconfirmed_email, unconfirmed_email: nil, email_confirmation_token: nil)
      render status: :ok, json: { success: 'Email confirmed successfully' }
    else
      head :bad_request
    end
  end

  def create_session
    @user = User.find_by(username: params[:username])
    if @user&.authenticate(params[:password])
      render status: :ok, json: { token: @user.auth_token }
    else
      render status: :bad_request, json: { error: 'Invalid username or password.' }
    end
  end

  def destroy_session
    current_user.regenerate_auth_token
    head :ok
  end

  def password_recovery
    @user = User.find_by(username: params[:username])
    if @user&.email.present?
      @user.regenerate_password_recovery_token
      UserMailer.password_recovery(@user).deliver_later
    end
    render status: :ok, json: { success: 'The information to reset the password has been sent.' }
  end

  def password_reset
    @user = User.find_by(password_recovery_token: params[:password_recovery_token])
    return render status: :ok, json: { success: 'Password reset successfully' } if @user&.update(password: params[:password], password_recovery_token: nil)

    head :bad_request
  end

  private

  def user_params
    params.require(:user).tap { |p| p[:unconfirmed_email] = p[:email] }.permit(:unconfirmed_email, :username, :password)
  end
end
