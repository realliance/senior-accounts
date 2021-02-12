# frozen_string_literal: true

class User < ApplicationRecord
  has_secure_password
  has_secure_token :auth_token
  has_secure_token :email_confirmation_token
  has_secure_token :password_recovery_token
  after_commit :send_confirmation_email, only: %i[create update], if: -> { saved_change_to_unconfirmed_email? && !unconfirmed_email.nil? }

  has_many :friendships, dependent: :destroy
  has_many :friends, -> { where(friendships: { status: 'accepted' }) }, through: :friendships
  has_many :pending_friends, -> { where(friendships: { status: 'pending' }) }, through: :friendships, source: :friend

  validates :email, length: 1..100, format: { with: URI::MailTo::EMAIL_REGEXP }, allow_nil: true
  validates :unconfirmed_email, exclusion: { in: ->(u) { [u.email] } }, length: 1..100, format: { with: URI::MailTo::EMAIL_REGEXP }, allow_nil: true
  validates :username, presence: true, uniqueness: true, length: 3..100
  validates :password, length: 10..72, allow_nil: true
  validates :auth_token, uniqueness: true, allow_nil: true
  validates :email_confirmation_token, uniqueness: true, allow_nil: true
  validates :password_recovery_token, uniqueness: true, allow_nil: true

  private

  def send_confirmation_email
    regenerate_email_confirmation_token
    UserMailer.email_confirmation(self, unconfirmed_email).deliver_later
  end
end
