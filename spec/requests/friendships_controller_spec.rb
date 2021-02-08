# frozen_string_literal: true

require 'rails_helper'

RSpec.describe FriendshipsController, type: :request do
  context 'when logged out' do
    let(:friend) { create(:user) }

    describe 'POST #create' do
      it 'renders an unauthorized response' do
        post friendship_url, as: :json
        expect(response).to have_http_status(:unauthorized)
      end
    end

    describe 'PATCH #update' do
      it 'renders an unauthorized response' do
        patch friendship_url, params: { id: friend.id.to_s }, as: :json
        expect(response).to have_http_status(:unauthorized)
      end
    end

    describe 'PUT #update' do
      it 'renders an unauthorized response' do
        put friendship_url, params: { id: friend.id.to_s }, as: :json
        expect(response).to have_http_status(:unauthorized)
      end
    end

    describe 'DELETE #destroy' do
      it 'renders an unauthorized response' do
        delete friendship_url, params: { id: friend.id.to_s }, as: :json
        expect(response).to have_http_status(:unauthorized)
      end
    end
  end

  context 'when logged in' do
    let(:valid_headers) do
      { authorization: "Token #{user.auth_token}" }
    end

    let(:user) { create(:user) }
    let(:friend) { create(:user) }

    describe 'POST #create' do
      it 'sends a friend request' do
        post friendship_url, params: { id: friend.id.to_s }, headers: valid_headers, as: :json
        expect(user.friends).to include(friend)
        expect(response.body).to match(a_string_including('Friend request has been sent.'))
        expect(user.friendships.where(status: 'pending').count).to eq(1)
        expect(friend.friendships.where(status: 'requested').count).to eq(1)
      end
    end

    it 'fails to send a self request' do
      post friendship_url, params: { id: user.id.to_s }, headers: valid_headers, as: :json
      expect(response.body).to match(a_string_including('Friend request could not be sent.'))
      expect(user.friends).not_to include(user)
    end

    it 'fails to send friend request if there is one already pending' do
      Friendship.request(user, friend)
      post friendship_url, params: { id: friend.id.to_s }, headers: valid_headers, as: :json
      expect(response.body).to match(a_string_including('Friend request could not be sent.'))
    end

    describe 'PUT #update' do
      it 'accepts a friend request' do
        Friendship.request(user, friend)
        put friendship_url, params: { id: friend.id.to_s }, headers: valid_headers, as: :json
        expect(response.body).to match(a_string_including('Friend request has been accepted.'))
        expect(user.friendships.where(status: 'accepted').count).to eq(1)
        expect(friend.friendships.where(status: 'accepted').count).to eq(1)
      end

      it 'fails to accept a nonexistent friend request  ' do
        put friendship_url, params: { id: friend.id.to_s }, headers: valid_headers, as: :json
        expect(response.body).to match(a_string_including('Friend request could not be accepted.'))
        expect(user.friendships.where(status: 'accepted').count).to eq(0)
        expect(friend.friendships.where(status: 'accepted').count).to eq(0)
      end
    end

    describe 'DELETE #destroy' do
      it 'removes a friendship' do
        Friendship.request(user, friend)
        delete friendship_url, params: { id: friend.id.to_s }, headers: valid_headers, as: :json
        expect(response.body).to match(a_string_including('Friend has been removed.'))
        expect(user.friends).not_to include(friend)
        expect(friend.friends).not_to include(user)
      end

      it 'fails to remove a nonexistent friend' do
        delete friendship_url, params: { id: friend.id.to_s }, headers: valid_headers, as: :json
        expect(response.body).to match(a_string_including('Friend could not be removed.'))
      end
    end
  end
end
