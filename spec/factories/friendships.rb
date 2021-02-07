# frozen_string_literal: true

FactoryBot.define do
  factory :friendship do
    user { build(:user) }
    friend { build(:user) }
    status { nil }
  end
end
