# frozen_string_literal: true

class Friends < ApplicationRecord
  belongs_to :sent_to, class_name: 'User'
  belongs_to :sent_by, class_name: 'User'

  enum status: { pending: 0, confirmed: 1 }
  scope :pending, -> { where(status: :pending) }
  scope :confirmed, -> { where(status: :confirmed) }

  enum invitation: { unsolicited: 0, invited: 1, accepted: 2 }
  scope :invited, -> { where(invitation: :invited) }
  scope :accepted, -> { where(invitation: :accepted) }

  def self.request(user, friend)
    return if (user == friend) || find_by(sent_by: user, sent_to: friend).present?

    user.friends_sent.create(sent_to: friend, status: :pending)
  end
end
