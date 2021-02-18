# frozen_string_literal: true

class PartiesController < ApplicationController
  before_action :check_token, :users
  skip_before_action :users, only: %i[show]

  def show
    @user = current_user
  end

  def create
    @member = Friends.find_by(sent_by: current_user, sent_to: @friend, status: :confirmed)
    if @member.nil? || @member.invited? || current_user.party_members.count >= 2
      render status: :bad_request, json: { error: 'Friend could not be invited.' }
    else
      @member.invited!
      render status: :ok, json: { success: 'Friend has been invited.' }
    end
  end

  def update
    @member = Friends.find_by(sent_by: @friend, sent_to: current_user, status: :confirmed)
    if @member.nil? || !@member.invited? || @member.party_members.count >= 2
      render status: :bad_request, json: { error: 'Invitation could not be accepted.' }
    else
      @member.accepted!
      render status: :ok, json: { success: 'Invitation accepted.' }
    end
  end

  def kick
    @member = Friends.find_by(sent_by: current_user, sent_to: @friend, status: :confirmed)
    if @member.nil? || !@member.accepted?
      render status: :bad_request, json: { error: 'Friend could not be kicked.' }
    else
      @member.unsolicited!
      render status: :ok, json: { success: 'Friend has been kicked.' }
    end
  end

  def destroy
    current_user.party_members.destroy
    current_user.invitations.destroy
    render status: :ok, json: { success: 'Party has been disbanded.' }
  end

  private

  def members
    @user = current_user
    head :bad_request unless (@friend = User.find_by(id: params[:id]))
  end
end
