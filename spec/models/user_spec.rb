# frozen_string_literal: true

require 'rails_helper'

RSpec.describe User, type: :model do
  let(:user) { build(:user) }

  it 'Can be created' do
    expect(user).to be_valid
  end

  it 'Ensures username presence' do
    user.username = nil
    expect(user).not_to be_valid
  end

  it 'Ensures email presence' do
    user.email = nil
    expect(user).not_to be_valid
  end

  it 'Ensures rating presence' do
    user.rating = nil
    expect(user).not_to be_valid
  end

  it 'Ensures resources presence' do
    user.resources = nil
    expect(user).not_to be_valid
  end
end
