# frozen_string_literal: true

require 'rails_helper'

RSpec.describe PartiesController, type: :request do
  context 'when logged out' do
    let(:friend) { create(:user) }

    describe 'GET #show' do
      it 'renders an unauthorized response' do
        get parties_url, as: :json
        expect(response).to have_http_status(:unauthorized)
      end
    end

    describe 'POST #create' do
      it 'renders an unauthorized response' do
        post parties_url, as: :json
        expect(response).to have_http_status(:unauthorized)
      end
    end

    describe 'POST #kick' do
      it 'renders an unauthorized response' do
        post parties_kick_url, params: { id: friend.id.to_s }, as: :json
        expect(response).to have_http_status(:unauthorized)
      end
    end

    describe 'PATCH #update' do
      it 'renders an unauthorized response' do
        patch parties_url, params: { id: friend.id.to_s }, as: :json
        expect(response).to have_http_status(:unauthorized)
      end
    end

    describe 'PUT #update' do
      it 'renders an unauthorized response' do
        put parties_url, params: { id: friend.id.to_s }, as: :json
        expect(response).to have_http_status(:unauthorized)
      end
    end

    describe 'DELETE #destroy' do
      it 'renders an unauthorized response' do
        delete parties_url, params: { id: friend.id.to_s }, as: :json
        expect(response).to have_http_status(:unauthorized)
      end
    end
  end

  context 'when logged in' do
    let(:user) { create(:user) }
    let(:friend) { create(:user) }

    let(:valid_headers) do
      { authorization: "Token #{user.auth_token}" }
    end

    let(:valid_headers_friend) do
      { authorization: "Token #{friend.auth_token}" }
    end

    describe 'GET #show' do
      it 'gets party' do
        get parties_url, headers: valid_headers, as: :json
        expect(response).to have_http_status(:ok)
      end
    end

    describe 'POST #create' do
      it 'sends a party invitation' do
        Friends.create(sent_by: user, sent_to: friend, status: :confirmed)
        post parties_url, params: { id: friend.id.to_s }, headers: valid_headers, as: :json
        expect(response.body).to match(a_string_including('Friend has been invited.'))
        expect(user.invitations_pending).to include(friend)
      end
    end

    it 'fails to send a self invitation' do
      post parties_url, params: { id: user.id.to_s }, headers: valid_headers, as: :json
      expect(response.body).to match(a_string_including('Friend could not be invited.'))
      expect(user.invitations_pending).not_to include(user)
    end

    it 'fails to send an invite if there is one already pending' do
      Friends.create(sent_by: user, sent_to: friend, status: :confirmed, invitation: :invited)
      post parties_url, params: { id: friend.id.to_s }, headers: valid_headers, as: :json
      expect(response.body).to match(a_string_including('Friend could not be invited.'))
    end

    describe 'PUT #update' do
      it 'accepts a party invitation' do
        Friends.create(sent_by: user, sent_to: friend, status: :confirmed, invitation: :invited)
        put parties_url, params: { id: user.id.to_s }, headers: valid_headers_friend, as: :json
        expect(response.body).to match(a_string_including('Invitation accepted.'))
        expect(user.party_members).to include(friend)
      end

      it 'fails to accept a nonexistent invitation' do
        Friends.create(sent_by: user, sent_to: friend, status: :confirmed, invitation: :unsolicited)
        put parties_url, params: { id: friend.id.to_s }, headers: valid_headers, as: :json
        expect(response.body).to match(a_string_including('Invitation could not be accepted.'))
        expect(user.party_members).not_to include(friend)
      end
    end

    describe 'DELETE #destroy' do
      it 'disbands a party' do
        Friends.create(sent_by: user, sent_to: friend, status: :confirmed, invitation: :accepted)
        delete parties_url, params: { id: friend.id.to_s }, headers: valid_headers, as: :json
        expect(response.body).to match(a_string_including('Party has been disbanded.'))
        expect(user.friends_pending).not_to include(friend)
      end
    end

    describe 'POST #kick' do
      it 'kicks a party member' do
        Friends.create(sent_by: user, sent_to: friend, status: :confirmed, invitation: :accepted)
        post parties_kick_url, params: { id: friend.id.to_s }, headers: valid_headers, as: :json
        expect(response.body).to match(a_string_including('Friend has been kicked.'))
        expect(user.party_members).not_to include(friend)
      end

      it 'fails to kick a friend that is not in party' do
        Friends.create(sent_by: user, sent_to: friend, status: :confirmed, invitation: :invited)
        post parties_kick_url, params: { id: friend.id.to_s }, headers: valid_headers, as: :json
        expect(response.body).to match(a_string_including('Friend could not be kicked.'))
      end
    end
  end
end
