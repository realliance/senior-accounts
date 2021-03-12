# frozen_string_literal: true

require 'rails_helper'

RSpec.describe PartiesController, type: :routing do
  describe 'routing' do
    it 'routes to #show via GET' do
      expect(get: '/parties').to route_to('parties#show')
    end

    it 'routes to #create via POST' do
      expect(post: '/parties').to route_to('parties#create')
    end

    it 'routes to #kick via POST' do
      expect(post: '/parties/kick').to route_to('parties#kick')
    end

    it 'routes to #update via PUT' do
      expect(put: '/parties').to route_to('parties#update')
    end

    it 'routes to #update via PATCH' do
      expect(patch: '/parties').to route_to('parties#update')
    end

    it 'routes to #destroy via DELETE' do
      expect(delete: '/parties').to route_to('parties#destroy')
    end
  end
end
