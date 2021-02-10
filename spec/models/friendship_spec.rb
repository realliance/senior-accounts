# frozen_string_literal: true

require 'rails_helper'

RSpec.describe Friendship, type: :model do
  let(:user) { create(:user) }
  let(:friend) { create(:user) }
  let(:friendship) { create(:friendship, user: user, friend: friend) }

  it 'is valid with valid attributes' do
    expect(friendship).to be_valid
  end

  it 'is invalid with no user' do
    friendship.user = nil
    expect(friendship).not_to be_valid
  end

  it 'is invalid with no friend' do
    friendship.friend = nil
    expect(friendship).not_to be_valid
  end

  it 'is valid with correct status' do
    friendship.status = 'accepted'
    expect(friendship).to be_valid
  end

  it 'is invalid with incorrect status' do
    expect { friendship.status = 'false' }.to raise_error(ArgumentError)
  end

  it 'sends a friend request' do
    described_class.request(user, friend)
    expect(user.pending_friends).to include(friend)
  end

  it 'accepts a friend request' do
    described_class.accept(friendship.user, friendship.friend)
    expect(user.friends.count).to eq(1)
  end

  it 'declines a friend request' do
    described_class.request(user, friend)
    described_class.remove(user, friend)
    expect(user.pending_friends.count).to eq(0)
    expect(friend.requested_friends.count).to eq(0)
  end

  it 'removes a friend' do
    described_class.request(user, friend)
    described_class.accept(user, friend)
    described_class.remove(user, friend)
    expect(user.friends.count).to eq(0)
    expect(friend.friends.count).to eq(0)
  end
end
