# frozen_string_literal: true

class Friendship < ApplicationRecord
  belongs_to :sent_to, class_name: 'User'
  belongs_to :sent_by, class_name: 'User'

  enum status: { pending: 0, accepted: 1 }

  scope :accepted, -> { where(status: :accepted) }
  scope :pending, -> { where(status: :pending) }

  def self.exists?(user, friend)
    return true unless find_by(sent_by: user, sent_to: friend).nil?
  end

  def self.request(user, friend)
    return if (user == friend) || Friendship.exists?(user, friend)

    user.friendships_sent.create(sent_to: friend, status: :pending)
  end
end
