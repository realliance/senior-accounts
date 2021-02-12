# frozen_string_literal: true

class Friendship < ApplicationRecord
  belongs_to :user
  belongs_to :friend, class_name: 'User'

  enum status: { pending: 0, accepted: 1 }

  def self.exists?(user, friend)
    return true unless find_by(user_id: user.id, friend_id: friend.id).nil?
  end

  def self.request(user, friend)
    return if (user == friend) || Friendship.exists?(user, friend)

    create(user: user, friend: friend, status: :pending)
  end
end
