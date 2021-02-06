# frozen_string_literal: true

class FriendshipsController < ApplicationController
  before_action :def_user
  def create
    Friendship.request(@user, @friend)
    render status: :ok, json: { success: 'Friend request has been sent.' }
  end

  def accept
    Friendship.accept(@user, @friend)
    render status: :ok, json: { success: 'Friend request has been accepted.' }
  end

  def remove
    Friendship.remove(@user, @friend)
    render status: :ok, json: { success: 'Friend has been removed.' }
  end

  private

  def def_user
    @user = current_user
    @friend = User.find(params[:username])
  end
end
