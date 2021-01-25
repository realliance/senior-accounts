# frozen_string_literal: true

class User < ApplicationRecord
  devise :database_authenticatable, :registerable,
         :recoverable, :validatable, :confirmable

  validates :username, presence: true, length: { minimum: 5, maximum: 20 }
  validates :email, presence: true
  validates :rating, presence: true
  validates :resources, presence: true
end
