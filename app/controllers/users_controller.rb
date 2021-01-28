# frozen_string_literal: true

class UsersController < ApplicationController
  skip_before_action :check_token, only: :create

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

  private

  def create_params
    params.require(:user).permit(:email, :username, :password, :password_confirmation)
  end

  def update_params
    params.require(:user).permit(:password, :password_confirmation)
  end
end