# frozen_string_literal: true

FactoryBot.define do
  factory :user do
    email { FFaker::Internet.free_email }
    password { FFaker::Internet.password }
    sequence(:username) { |n| "user#{n}" }
    rating { FFaker.rand(2000) }
    resources { FFaker.rand(2000) }
  end
end
