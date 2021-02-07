# frozen_string_literal: true

class Friendship < ApplicationRecord
  belongs_to :user
  belongs_to :friend, class_name: 'User'

  enum status: { requested: 0, pending: 1, accepted: 2 }

  def self.exists?(user, friend)
    return true unless find_by(user_id: user.id, friend_id: friend.id).nil?
  end

  def self.request(user, friend)
    return if (user == friend) || Friendship.exists?(user, friend)

    transaction do
      create(user: user, friend: friend, status: :pending)
      create(user: friend, friend: user, status: :requested)
    end
  end

  def self.accept(user, friend)
    transaction do
      accept_request(user, friend)
      accept_request(friend, user)
    end
  end

  def self.remove(user, friend)
    friendship = find_by(user_id: user.id, friend_id: friend.id)
    inverse_friendship = find_by(user_id: friend.id, friend_id: user.id)

    return unless friendship && inverse_friendship

    friendship.destroy
    inverse_friendship.destroy
  end

  def self.accept_request(user, friend)
    return unless (request = find_by(user_id: user.id, friend_id: friend.id))

    request.accepted!
  end
end
