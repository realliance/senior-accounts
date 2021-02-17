# frozen_string_literal: true

class Friends < ApplicationRecord
  belongs_to :sent_to, class_name: 'User'
  belongs_to :sent_by, class_name: 'User'

  enum status: { pending: 0, confirmed: 1 }
  scope :pending, -> { where(status: :pending) }
  scope :confirmed, -> { where(status: :confirmed) }

  # enum invitation: { pending: 0, accepted: 1 }
  # scope :invited, -> { where(status: :invited) }
  # scope :confirmed, -> { where(status: :confirmed) }

  def self.exists?(user, friend)
    return true unless find_by(sent_by: user, sent_to: friend).nil?
  end

  def self.request(user, friend)
    return if (user == friend) || Friends.exists?(user, friend)

    user.friends_sent.create(sent_to: friend, status: :pending)
  end
end
