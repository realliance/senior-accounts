# frozen_string_literal: true

class FriendshipsController < ApplicationController
  before_action :check_token, :users
  skip_before_action :users, only: %i[show]

  def show
    @user = current_user
  end

  def create
    @friendship = Friendship.request(@user, @friend)
    if @friendship.nil?
      render status: :bad_request, json: { error: 'Friend request could not be sent.' }
    else
      render status: :ok, json: { success: 'Friend request has been sent.' }
    end
  end

  def update
    @friendship = Friendship.find_by(user: @friend, friend: current_user, status: 'pending')
    if @friendship.nil?
      render status: :bad_request, json: { error: 'Friend request could not be accepted.' }
    else
      @friendship.accepted!
      render status: :ok, json: { success: 'Friend request has been accepted.' }
    end
  end

  def destroy
    @friendship = Friendship.find_by(user: current_user, friend: @friend).presence || Friendship.find_by(user: @friend, friend: current_user).presence
    if @friendship.nil?
      render status: :bad_request, json: { error: 'Friend could not be removed.' }
    else
      @friendship.destroy
      render status: :ok, json: { success: 'Friend has been removed.' }
    end
  end

  private

  def users
    @user = current_user
    head :bad_request unless (@friend = User.find_by(id: params[:id]))
  end
end
