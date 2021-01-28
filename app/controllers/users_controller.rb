# frozen_string_literal: true

class UsersController < ApplicationController
  def create
    @user = User.create(create_params)
    if @user.save
      render statsus: created, view: :show
    else
      render status: :bad_request, json: @user.errors
    end
  end

  def update
    # if current_user&.update(update_params)
    # render :show
    # else
    # render status: :bad_request, json: current_user.errors
    # end
  end

  private

  def create_params
    params.require(:user).permit(:email, :username, :password, :password_confirmation)
  end

  def update_params
    params.require(:user).permit(:password, :password_confirmation)
  end
end
