# frozen_string_literal: true

class FriendsController < ApplicationController
  before_action :check_token, :users
  skip_before_action :users, only: %i[show]

  def show
    @user = current_user
  end

  def create
    @friendship = Friends.request(current_user, @friend)
    if @friendship.nil?
      render status: :bad_request, json: { error: 'Friend request could not be sent.' }
    else
      render status: :ok, json: { success: 'Friend request has been sent.' }
    end
  end

  def update
    @friendship = Friends.find_by(sent_by: @friend, sent_to: current_user, status: 'pending')
    if @friendship.nil?
      render status: :bad_request, json: { error: 'Friend request could not be accepted.' }
    else
      @friendship.confirmed!
      render status: :ok, json: { success: 'Friend request has been accepted.' }
    end
  end

  def destroy
    @friendship = Friends.find_by(sent_by: @friend, sent_to: current_user).presence || Friends.find_by(sent_by: current_user, sent_to: @friend).presence
    if @friendship.nil?
      render status: :bad_request, json: { error: 'Friend could not be removed.' }
    else
      @friendship.destroy
      render status: :ok, json: { success: 'Friend has been removed.' }
    end
  end

  def invite
    @friendship = Friends.find_by(sent_by: current_user, sent_to: @friend, status: :confirmed)
    if @friendship.nil? || @friendship.invited? || current_user.party_members.count >= 2
      render status: :bad_request, json: { error: 'Friend could not be invited.' }
    else
      @friendship.invited!
      render status: :ok, json: { success: 'Friend has been invited.' }
    end
  end

  def accept_invitation
    @friendship = Friends.find_by(sent_by: @friend, sent_to: current_user, status: :confirmed)
    if @friendship.nil? || !@friendship.invited? || @friend.party_members.count >= 2
      render status: :bad_request, json: { error: 'Invitation could not be accepted.' }
    else
      @friendship.accepted!
      render status: :ok, json: { success: 'Invitation accepted.' }
    end
  end

  def kick
    @friendship = Friends.find_by(sent_by: current_user, sent_to: @friend, status: :confirmed)
    if @friendship.nil? || !@friendship.accepted?
      render status: :bad_request, json: { error: 'Friend could not be kicked.' }
    else
      @friendship.unsolicited!
      render status: :ok, json: { success: 'Friend has been kicked.' }
    end
  end

  def disband
    current_user.party_members.destroy
    current_user.invitations.destroy
    render status: :ok, json: { success: 'Party has been disbanded.' }
  end

  private

  def users
    @user = current_user
    head :bad_request unless (@friend = User.find_by(id: params[:id]))
  end
end
