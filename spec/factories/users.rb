# frozen_string_literal: true

FactoryBot.define do
  factory :user do
    sequence(:username) { |n| "user#{n}" }
    unconfirmed_email { FFaker::Internet.safe_email(username) }
    password { FFaker::Internet.password(10, 72) }
    email_confirmation_token { 'token' }
  end
end
