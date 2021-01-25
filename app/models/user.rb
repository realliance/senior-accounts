# frozen_string_literal: true

class User < ApplicationRecord
  # Include default devise modules. Others available are:
  # :confirmable, :lockable, :timeoutable, :trackable and :omniauthable
  devise :database_authenticatable, :registerable,
         :recoverable, :validatable

  validates :username, presence: true, length: { minimum: 5, maximum: 20 }
  validates :email, presence: true
  validates :rating, presence: true
  validates :resources, presence: true

end
