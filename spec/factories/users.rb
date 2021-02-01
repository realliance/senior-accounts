# frozen_string_literal: true

FactoryBot.define do
  factory :user do
    sequence(:username) { |n| "user#{n}" }
    email { FFaker::Internet.safe_email(username) }
    password { FFaker::Internet.password(10, 72) }
  end

  factory :unconfirmed_user, class: 'User' do
    sequence(:username) { |n| "user#{n}" }
    unconfirmed_email { FFaker::Internet.safe_email(username) }
    password { FFaker::Internet.password(10, 72) }
    email_confirmation_token { SecureRandom.urlsafe_base64 }
  end
end
