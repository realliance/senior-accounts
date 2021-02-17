# frozen_string_literal: true

require 'rails_helper'

RSpec.describe FriendsController, type: :routing do
  describe 'routing' do
    it 'routes to #show via GET' do
      expect(get: '/friends').to route_to('friends#show')
    end

    it 'routes to #create via POST' do
      expect(post: '/friends').to route_to('friends#create')
    end

    it 'routes to #update via PUT' do
      expect(put: '/friends').to route_to('friends#update')
    end

    it 'routes to #update via PATCH' do
      expect(patch: '/friends').to route_to('friends#update')
    end

    it 'routes to #destroy_session via DELETE' do
      expect(delete: '/friends').to route_to('friends#destroy')
    end
  end
end
