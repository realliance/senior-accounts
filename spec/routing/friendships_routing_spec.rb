# frozen_string_literal: true

require 'rails_helper'

RSpec.describe FriendshipsController, type: :routing do
  describe 'routing' do
    it 'routes to #show via GET' do
      expect(get: '/friendship').to route_to('friendships#show')
    end

    it 'routes to #create via POST' do
      expect(post: '/friendship').to route_to('friendships#create')
    end

    it 'routes to #update via PUT' do
      expect(put: '/friendship').to route_to('friendships#update')
    end

    it 'routes to #update via PATCH' do
      expect(patch: '/friendship').to route_to('friendships#update')
    end

    it 'routes to #destroy_session via DELETE' do
      expect(delete: '/friendship').to route_to('friendships#destroy')
    end
  end
end
