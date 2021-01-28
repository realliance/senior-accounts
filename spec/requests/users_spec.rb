# frozen_string_literal: true

require 'rails_helper'

RSpec.describe '/user', type: :request do
  let(:valid_attributes) do
    FactoryBot.attributes_for(:user)
  end

  let(:invalid_attributes) do
    FactoryBot.attributes_for(:user, username: 'a')
  end

  describe 'POST /create' do
    context 'with valid parameters' do
      it 'creates a new User' do
        expect do
          post user_url, params: { user: valid_attributes }, as: :json
        end.to change(User, :count).by(1)
      end

      it 'renders a JSON response with the new user' do
        post user_url, params: { user: valid_attributes }, as: :json
        expect(response).to have_http_status(:created)
        expect(response.content_type).to match(a_string_including('application/json'))
      end
    end

    context 'with invalid parameters' do
      it 'does not create a new User' do
        expect do
          post user_url, params: { user: invalid_attributes }, as: :json
        end.to change(User, :count).by(0)
      end

      it 'renders a JSON response with errors for the new user' do
        post user_url, params: { user: invalid_attributes }, as: :json
        expect(response).to have_http_status(:bad_request)
        expect(response.content_type).to match(a_string_including('application/json'))
      end
    end
  end

  context 'when logged out' do
    describe 'GET /show' do
      it 'renders an unauthorized response' do
        get user_url, as: :json
        expect(response).to have_http_status(:unauthorized)
      end
    end

    describe 'PATCH /update' do
      it 'renders an unauthorized response' do
        patch user_url, params: { user: valid_attributes }, as: :json
        expect(response).to have_http_status(:unauthorized)
      end
    end
  end

  context 'when logged in' do
    let(:user) do
      FactoryBot.create(:user)
    end

    let(:valid_headers) do
      { authorization: "Bearer #{user.auth_token}" }
    end

    describe 'GET /show' do
      it 'renders a successful response' do
        get user_url(user), headers: valid_headers, as: :json
        expect(response).to be_successful
      end
    end

    describe 'PATCH /update' do
      context 'with valid parameters' do
        let(:new_attributes) do
          { password: 'devise_sucks', password_confirmation: 'devise_sucks' }
        end

        it 'updates the requested user' do
          patch user_url, params: { user: new_attributes }, headers: valid_headers, as: :json
          user.reload
          expect(user.authenticate('devise_sucks')).to be_true
        end

        it 'renders a JSON response with the user' do
          patch user_url, params: { user: new_attributes }, headers: valid_headers, as: :json
          expect(response).to have_http_status(:ok)
          expect(response.content_type).to match(a_string_including('application/json'))
        end
      end

      context 'with invalid parameters' do
        it 'renders a JSON response with errors for the user' do
          patch user_url, params: { user: invalid_attributes }, headers: valid_headers, as: :json
          expect(response).to have_http_status(:bad_request)
          expect(response.content_type).to match(a_string_including('application/json'))
        end
      end
    end
  end
end
