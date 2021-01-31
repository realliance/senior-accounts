# frozen_string_literal: true

class User < ApplicationRecord
  has_secure_password
  has_secure_token :auth_token
  has_secure_token :email_confirmation_token
  after_create :send_confirmation_email
  after_update :send_confirmation_email, if: :unconfirmed_email_changed?

  validates :email, uniqueness: true, length: 1..100, format: { with: URI::MailTo::EMAIL_REGEXP }, allow_blank: true
  validates :unconfirmed_email, exclusion: { in: ->(u) { [u.email] } }, length: 1..100, format: { with: URI::MailTo::EMAIL_REGEXP }, allow_blank: true
  validates :username, presence: true, uniqueness: true, length: 3..100
  validates :password, length: 10..72, allow_nil: true
  validates :auth_token, uniqueness: true
  validates :email_confirmation_token, uniqueness: true, allow_nil: true

  private

  def send_confirmation_email
    @user.regenerate_email_confirmation_token
    UserMailer.email_confirmation(self, unconfirmed_email).deliver_later
  end
end
