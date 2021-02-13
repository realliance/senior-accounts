# frozen_string_literal: true

class User < ApplicationRecord
  has_secure_password
  has_secure_token :auth_token
  has_secure_token :email_confirmation_token
  has_secure_token :password_recovery_token
  after_commit :send_confirmation_email, only: %i[create update], if: -> { saved_change_to_unconfirmed_email? && !unconfirmed_email.nil? }

  has_many :invitations_sent, class_name: 'Friendship', foreign_key: 'sent_by_id', inverse_of: 'sent_by', dependent: :destroy
  has_many :invitations_received, class_name: 'Friendship', foreign_key: 'sent_to_id', inverse_of: 'sent_to', dependent: :destroy
  has_many :connections, -> { merge(Friendship.accepted) }, through: :invitations_sent, source: :sent_to
  has_many :inverse_connections, -> { merge(Friendship.accepted) }, through: :invitations_received, source: :sent_by
  has_many :pending_requests, -> { merge(Friendship.pending) }, through: :invitations_sent, source: :sent_to
  has_many :received_requests, -> { merge(Friendship.pending) }, through: :invitations_received, source: :sent_by

  validates :email, length: 1..100, format: { with: URI::MailTo::EMAIL_REGEXP }, allow_nil: true
  validates :unconfirmed_email, exclusion: { in: ->(u) { [u.email] } }, length: 1..100, format: { with: URI::MailTo::EMAIL_REGEXP }, allow_nil: true
  validates :username, presence: true, uniqueness: true, length: 3..100
  validates :password, length: 10..72, allow_nil: true
  validates :auth_token, uniqueness: true, allow_nil: true
  validates :email_confirmation_token, uniqueness: true, allow_nil: true
  validates :password_recovery_token, uniqueness: true, allow_nil: true

  def friends
    connections + inverse_connections
  end

  private

  def send_confirmation_email
    regenerate_email_confirmation_token
    UserMailer.email_confirmation(self, unconfirmed_email).deliver_later
  end
end
