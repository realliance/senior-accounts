# frozen_string_literal: true

FactoryBot.define do
  factory :friends, class: 'Friends' do
    sent_by factory: :user
    association :sent_to, factory: :user
  end
end
