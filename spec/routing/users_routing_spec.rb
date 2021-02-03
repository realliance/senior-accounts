# frozen_string_literal: true

require 'rails_helper'

RSpec.describe UsersController, type: :routing do
  describe 'routing' do
    it 'routes to #show via GET' do
      expect(get: '/user').to route_to('users#show')
    end

    it 'routes to #create via POST' do
      expect(post: '/user').to route_to('users#create')
    end

    it 'routes to #update via PUT' do
      expect(put: '/user').to route_to('users#update')
    end

    it 'routes to #update via PATCH' do
      expect(patch: '/user').to route_to('users#update')
    end

    it 'routes to #create_session via POST' do
      expect(post: '/session').to route_to('users#create_session')
    end

    it 'routes to #destroy_session via DELETE' do
      expect(delete: '/session').to route_to('users#destroy_session')
    end

    it 'routes to #confirm_email via GET' do
      expect(get: '/confirm/token').to route_to(
        controller: 'users',
        action: 'confirm_email',
        email_confirmation_token: 'token'
      )
    end

    it 'routes to #password_recovery via POST' do
      expect(post: '/password/recovery').to route_to('users#password_recovery')
    end

    it 'routes to #password_reset via GET' do
      expect(get: '/password/token').to route_to(
        controller: 'users',
        action: 'password_reset',
        password_recovery_token: 'token'
      )
    end
  end
end
