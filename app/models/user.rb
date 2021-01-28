# frozen_string_literal: true

class User < ApplicationRecord
  has_secure_password

  validates :email, presence: true, uniqueness: true, length: 1..100
  validates :username, presence: true, uniqueness: true, length: 3..100
  validates :password, length: 10..71
end
