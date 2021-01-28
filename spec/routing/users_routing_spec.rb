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
  end
end
