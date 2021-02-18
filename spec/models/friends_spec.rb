# frozen_string_literal: true

require 'rails_helper'

RSpec.describe Friends, type: :model do
  let(:requester) { create(:user) }
  let(:requestee) { create(:user) }
  let(:friendship) { create(:friends, sent_by_id: requester.id, sent_to_id: requestee.id) }

  it 'is valid with valid attributes' do
    expect(friendship).to be_valid
  end

  it 'is invalid with no requester' do
    friendship.sent_by = nil
    expect(friendship).not_to be_valid
  end

  it 'is invalid with no requestee' do
    friendship.sent_to = nil
    expect(friendship).not_to be_valid
  end

  it 'is valid with correct status' do
    friendship.status = 'confirmed'
    expect(friendship).to be_valid
  end

  it 'is invalid with incorrect status' do
    expect { friendship.status = 'false' }.to raise_error(ArgumentError)
  end

  it 'sends a friend request' do
    described_class.request(requester, requestee)
    expect(requester.friends_pending).to include(requestee)
  end
end
