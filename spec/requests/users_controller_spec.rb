# frozen_string_literal: true

require 'rails_helper'

RSpec.describe UsersController, type: :request do
  let(:valid_attributes) do
    attributes_for(:user)
  end

  let(:invalid_attributes) do
    attributes_for(:user, email: 'a')
  end

  describe 'POST #create' do
    context 'with valid parameters' do
      it 'creates a new User' do
        expect do
          post user_url, params: { user: valid_attributes }, as: :json
        end.to change(User, :count).by(1)
      end

      it 'enqueues email to be delivered later' do
        assert_enqueued_jobs 1 do
          post user_url, params: { user: valid_attributes }, as: :json
        end
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

  describe 'POST #create_sessions' do
    let(:user) do
      User.create(valid_attributes)
    end

    context 'with valid credentials' do
      it 'returns a token' do
        post session_url, params: { username: user.username, password: valid_attributes[:password] }, as: :json
        expect(response).to have_http_status(:ok)
        expect(response.content_type).to match(a_string_including('application/json'))
        expect(response.body).to eq({ token: user.auth_token }.to_json)
      end
    end

    context 'with invalid credentials' do
      it 'renders a bad request response' do
        post session_url, params: { email: user.email, password: "a#{valid_attributes[:password]}" }, as: :json
        expect(response).to have_http_status(:bad_request)
      end
    end
  end

  describe 'GET #confirm_email' do
    let(:user) do
      create(:unconfirmed_user)
    end

    context 'with valid email confirmation token' do
      it 'confirms email' do
        get confirm_email_url(email_confirmation_token: user.email_confirmation_token)
        expect(response).to have_http_status(:ok)
        expect(response.content_type).to match(a_string_including('application/json'))
        expect(response.body).to match(a_string_including('Email confirmed successfully'))
      end
    end

    context 'with invalid email confirmation token' do
      it 'renders a bad request response' do
        get confirm_email_url(email_confirmation_token: 'invalid_token')
        expect(response).to have_http_status(:bad_request)
        expect(response.content_type).to match(a_string_including('application/json'))
        expect(response.body).to match(a_string_including('Invalid request'))
      end
    end
  end

  context 'when logged out' do
    describe 'GET #show' do
      it 'renders an unauthorized response' do
        get user_url, as: :json
        expect(response).to have_http_status(:unauthorized)
      end
    end

    describe 'PATCH #update' do
      it 'renders an unauthorized response' do
        patch user_url, params: { user: valid_attributes }, as: :json
        expect(response).to have_http_status(:unauthorized)
      end
    end

    describe 'DELETE #destroy_session' do
      it 'renders an unauthorized response' do
        delete session_url, as: :json
        expect(response).to have_http_status(:unauthorized)
      end
    end
  end

  context 'when logged in' do
    let(:user) do
      create(:user)
    end

    let(:valid_headers) do
      { authorization: "Token #{user.auth_token}" }
    end

    describe 'GET #show' do
      it 'renders a JSON response with the current user' do
        get user_url, headers: valid_headers, as: :json
        expect(response).to be_successful
        expect(response.content_type).to match(a_string_including('application/json'))
      end
    end

    describe 'PATCH #update' do
      context 'with valid parameters' do
        let(:new_attributes) do
          attributes_for(:user, email: 'devise_sucks@gmail.com', password: 'devise_sucks')
        end

        it 'updates the requested user' do
          patch user_url, params: { user: new_attributes }, headers: valid_headers, as: :json
          user.reload
          expect(user.authenticate('devise_sucks')).to be_truthy
          expect(user.unconfirmed_email).to eq('devise_sucks@gmail.com')
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

    describe 'DELETE #destroy_session' do
      it 'renders an ok response' do
        delete session_url, headers: valid_headers, as: :json
        expect(response).to have_http_status(:ok)
      end

      it 'resets the token' do
        token = user.auth_token
        delete session_url, headers: valid_headers, as: :json
        user.reload
        expect(user.auth_token).not_to equal(token)
      end
    end
  end
end
