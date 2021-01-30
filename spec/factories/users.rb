# frozen_string_literal: true

FactoryBot.define do
  factory :user do
    sequence(:username) { |n| "user#{n}" }
    email { FFaker::Internet.safe_email(username) }
    password { FFaker::Internet.password(10, 72) }
    sequence(:activated) { true }
    sequence(:email_confirmation_token) { 'token' }
  end
end
