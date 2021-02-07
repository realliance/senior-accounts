# frozen_string_literal: true

require 'rails_helper'

RSpec.describe Friendship, type: :model do
  let(:friendship) { build(:friendship) }
  let(:user) { build(:user) }
  let(:friend) { build(:user) }

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
    expect(user.friends).to include(friend)
  end

  it 'accepts a friend request' do
    described_class.request(user, friend)
    described_class.accept(user, friend)
    expect(user.friendships.where(status: 'accepted').count).to eq(1)
    expect(friend.friendships.where(status: 'accepted').count).to eq(1)
  end

  it 'declines a friend request' do
    described_class.request(user, friend)
    described_class.remove(user, friend)
    expect(user.friendships.where(status: 'pending').count).to eq(0)
    expect(friend.friendships.where(status: 'requested').count).to eq(0)
  end

  it 'removes a friend' do
    described_class.request(user, friend)
    described_class.accept(user, friend)
    described_class.remove(user, friend)
    expect(user.friendships.where(status: 'accepted').count).to eq(0)
    expect(friend.friendships.where(status: 'accepted').count).to eq(0)
  end
end
