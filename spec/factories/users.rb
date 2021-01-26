# frozen_string_literal: true

FactoryBot.define do
  factory :user, class: 'User' do
    email { Faker::Internet.free_email }
    password { Faker::Internet.password }
    username { Faker::Internet.username }
    rating { Faker::Number.number(digits: 10) }
    resources { Faker::Number.number(digits: 10) }
  end
end
