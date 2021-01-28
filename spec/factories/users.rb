# frozen_string_literal: true

FactoryBot.define do
  factory :user do
    sequence(:username) { |n| "user#{n}" }
    email { FFaker::Internet.safe_email(username) }
    password { FFaker::Internet.password(10, 72) }
    password_confirmation { password }
  end
end