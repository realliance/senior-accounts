# frozen_string_literal: true

class User < ApplicationRecord
  has_secure_password
  has_secure_token :auth_token
  has_secure_token :email_confirmation_token
  has_secure_token :password_recovery_token
  after_commit :send_confirmation_email, only: %i[create update], if: -> { saved_change_to_unconfirmed_email? && !unconfirmed_email.nil? }

  validates :email, length: 1..100, format: { with: URI::MailTo::EMAIL_REGEXP }, allow_nil: true
  validates :unconfirmed_email, exclusion: { in: ->(u) { [u.email] } }, length: 1..100, format: { with: URI::MailTo::EMAIL_REGEXP }, allow_nil: true
  validates :username, presence: true, uniqueness: true, length: 3..100
  validates :password, length: 10..72, allow_nil: true
  validates :auth_token, uniqueness: true, allow_nil: true
  validates :email_confirmation_token, uniqueness: true, allow_nil: true
  validates :password_recovery_token, uniqueness: true, allow_nil: true

  # Request associations.
  has_many :requests_sent, class_name: 'Friends', foreign_key: 'sent_by_id', inverse_of: 'sent_by', dependent: :destroy
  has_many :requests_received, class_name: 'Friends', foreign_key: 'sent_to_id', inverse_of: 'sent_to', dependent: :destroy

  # Friendship associations.
  has_many :friended, -> { merge(Friends.confirmed) }, through: :requests_sent, source: :sent_to
  has_many :friended_by, -> { merge(Friends.confirmed) }, through: :requests_received, source: :sent_by
  has_many :friends_pending, -> { merge(Friends.pending) }, through: :requests_sent, source: :sent_to
  has_many :friends_awaiting, -> { merge(Friends.pending) }, through: :requests_received, source: :sent_by

  def friends
    friended + friended_by
  end

  private

  def send_confirmation_email
    regenerate_email_confirmation_token
    UserMailer.email_confirmation(self, unconfirmed_email).deliver_later
  end
end
