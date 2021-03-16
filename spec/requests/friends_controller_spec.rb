# frozen_string_literal: true

require 'rails_helper'

RSpec.describe FriendsController, type: :request do
  context 'when logged out' do
    let(:friend) { create(:user) }

    describe 'GET #show' do
      it 'renders an unauthorized response' do
        get friends_url, as: :json
        expect(response).to have_http_status(:unauthorized)
      end
    end

    describe 'POST #create' do
      it 'renders an unauthorized response' do
        post friends_url, as: :json
        expect(response).to have_http_status(:unauthorized)
      end
    end

    describe 'PATCH #update' do
      it 'renders an unauthorized response' do
        patch friends_url, params: { id: friend.id.to_s }, as: :json
        expect(response).to have_http_status(:unauthorized)
      end
    end

    describe 'PUT #update' do
      it 'renders an unauthorized response' do
        put friends_url, params: { id: friend.id.to_s }, as: :json
        expect(response).to have_http_status(:unauthorized)
      end
    end

    describe 'DELETE #destroy' do
      it 'renders an unauthorized response' do
        delete friends_url, params: { id: friend.id.to_s }, as: :json
        expect(response).to have_http_status(:unauthorized)
      end
    end
  end

  context 'when logged in' do
    let(:valid_headers) do
      { authorization: "Token #{user.auth_token}" }
    end

    let(:valid_headers_friend) do
      { authorization: "Token #{friend.auth_token}" }
    end

    let(:user) { create(:user) }
    let(:friend) { create(:user) }

    describe 'GET #show' do
      it 'gets friend list' do
        get friends_url, headers: valid_headers, as: :json
        expect(response).to have_http_status(:ok)
      end
    end

    describe 'POST #create' do
      it 'sends a friend request' do
        post friends_url, params: { id: friend.id.to_s }, headers: valid_headers, as: :json
        expect(response.body).to match(a_string_including('Friend request has been sent.'))
        expect(user.friends_pending).to include(friend)
      end
    end

    it 'fails to send a self request' do
      post friends_url, params: { id: user.id.to_s }, headers: valid_headers, as: :json
      expect(response.body).to match(a_string_including('Friend request could not be sent.'))
      expect(user.friends).not_to include(user)
    end

    it 'fails to send friend request if there is one already pending' do
      Friends.request(user, friend)
      post friends_url, params: { id: friend.id.to_s }, headers: valid_headers, as: :json
      expect(response.body).to match(a_string_including('Friend request could not be sent.'))
    end

    describe 'PUT #update' do
      it 'accepts a friend request' do
        Friends.request(friend, user)
        put friends_url, params: { id: friend.id.to_s }, headers: valid_headers, as: :json
        expect(response.body).to match(a_string_including('Friend request has been accepted.'))
        expect(friend.friends).to include(user)
      end

      it 'fails to accept a nonexistent friend request  ' do
        put friends_url, params: { id: friend.id.to_s }, headers: valid_headers, as: :json
        expect(response.body).to match(a_string_including('Friend request could not be accepted.'))
        expect(user.friends).not_to include(friend)
        expect(friend.friends).not_to include(user)
      end
    end

    describe 'DELETE #destroy' do
      it 'removes a friends request' do
        Friends.request(user, friend)
        delete friends_url, params: { id: friend.id.to_s }, headers: valid_headers, as: :json
        expect(response.body).to match(a_string_including('Friend has been removed.'))
        expect(user.friends_pending).not_to include(friend)
      end

      it 'removes a friends' do
        Friends.create(sent_by: user, sent_to: friend, status: 'confirmed')
        delete friends_url, params: { id: friend.id.to_s }, headers: valid_headers, as: :json
        expect(user.friends).not_to include(friend)
      end

      it 'fails to remove a nonexistent friend' do
        delete friends_url, params: { id: friend.id.to_s }, headers: valid_headers, as: :json
        expect(response.body).to match(a_string_including('Friend could not be removed.'))
      end
    end
  end
end
