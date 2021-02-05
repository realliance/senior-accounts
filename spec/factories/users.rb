# frozen_string_literal: true

FactoryBot.define do
  factory :user do
    sequence(:username) { |n| "user#{n}" }
    email { FFaker::Internet.safe_email(username) }
    password { FFaker::Internet.password(10, 72) }
    password_recovery_token { regenerate_password_recovery_token }
  end

  factory :unconfirmed_user, class: 'User' do
    sequence(:username) { |n| "user#{n}" }
    unconfirmed_email { FFaker::Internet.safe_email(username) }
    password { FFaker::Internet.password(10, 72) }
    email_confirmation_token { regenerate_email_confirmation_token }
  end
end
