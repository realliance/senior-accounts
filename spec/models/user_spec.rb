# frozen_string_literal: true

require 'rails_helper'

RSpec.describe User, type: :model do
  let(:user) { build(:random_user) }

  it 'Can be created' do
    expect(user.save).to eq(true)
  end

  it 'Ensures username presence' do
    user.username = nil
    expect(user.save).to eq(false)
  end

  it 'Ensures email presence' do
    user.email = nil
    expect(user.save).to eq(false)
  end

  it 'Ensures rating presence' do
    user.rating = nil
    expect(user.save).to eq(false)
  end

  it 'Ensures resources presence' do
    user.resources = nil
    expect(user.save).to eq(false)
  end
end
