# frozen_string_literal: true

FactoryBot.define do
  factory :friendship, class: 'Friendship' do
    user
    association :friend, factory: :user
  end
end
