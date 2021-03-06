# frozen_string_literal: true

class UsersController < ApplicationController
  skip_before_action :check_token, except: %i[show update destroy_session]

  def show
    @user = current_user
  end

  def register
    @user = User.new
  end

  def create
    @user = User.create(user_params)
    if @user.save
      render :confirmation, formats: [:html], locals: { title: 'Success!', body: 'Your account has been created.' }, status: :created
    else
      render :register, formats: [:html], status: :bad_request
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
      render :confirmation, formats: [:html], locals: { title: 'Success!', body: 'Your email has been confirmed.' }
    else
      render :error, formats: [:html], locals: { title: 'Email Confirmation' }, status: :bad_request
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

    render :confirmation, formats: [:html], locals: { title: 'Email Sent', body: "If there is an account registered to  #{params[:username]} we have sent instructions for how to reset your password." } if params[:commit] == 'Recover Account'
  end

  def password_reset
    @user = User.find_by(password_recovery_token: params[:password_recovery_token])
    render :error, formats: [:html], locals: { title: 'Reset Password' }, status: :bad_request if @user.nil?
  end

  def password_update
    @user = User.find_by(password_recovery_token: params[:password_recovery_token])
    if @user&.update(password_params)
      render :confirmation, formats: [:html], locals: { title: 'Success!', body: 'Your password has been updated.' }
    elsif @user
      render :password_reset, formats: [:html]
    else
      render :error, formats: [:html], locals: { title: 'Reset Password' }, status: :bad_request
    end
  end

  private

  def user_params
    params.require(:user).tap { |p| p[:unconfirmed_email] = p[:email] }.permit(:unconfirmed_email, :username, :password)
  end

  def password_params
    params.require(:user).permit(:password, :password_confirmation).tap { |p| p[:password_recovery_token] = nil }
  end
end
