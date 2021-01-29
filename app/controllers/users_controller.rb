# frozen_string_literal: true

class UsersController < ApplicationController
  skip_before_action :check_token, only: %i[create create_session]

  def create
    @user = User.create(create_params)
    if @user.save
      render status: :created, action: :show
    else
      render status: :bad_request, json: @user.errors
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
    if @user&.authenticate(params[:password])
      render json: { token: @user.auth_token }
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
