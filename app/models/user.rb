# frozen_string_literal: true

class User < ApplicationRecord
  has_secure_password
  has_secure_token :auth_token

  validates :email, presence: true, uniqueness: true, length: 1..100, format: { with: URI::MailTo::EMAIL_REGEXP }
  validates :username, presence: true, uniqueness: true, length: 3..100
  validates :password, length: 10..72, allow_blank: true
  validates :auth_token, uniqueness: true
end
