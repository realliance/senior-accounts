# frozen_string_literal: true

class FriendshipsController < ApplicationController
  before_action :check_token, :users

  def create
    @friendship = Friendship.request(@user, @friend)
    if @friendship.nil?
      render status: :bad_request, json: { error: 'Friend request could not be sent.' }
    else
      render status: :ok, json: { success: 'Friend request has been sent.' }
    end
  end

  def update
    @friendship = Friendship.accept(@user, @friend)
    if @friendship.nil?
      render status: :bad_request, json: { error: 'Friend request could not be accepted.' }
    else
      render status: :ok, json: { success: 'Friend request has been accepted.' }
    end
  end

  def destroy
    @friendship = Friendship.remove(@user, @friend)
    if @friendship.nil?
      render status: :bad_request, json: { error: 'Friend could not be removed.' }
    else
      render status: :ok, json: { success: 'Friend has been removed.' }
    end
  end

  private

  def users
    @user = current_user
    head :bad_request unless (@friend = User.find_by(id: params[:id]))
  end
end
