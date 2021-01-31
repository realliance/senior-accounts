# frozen_string_literal: true

require 'rails_helper'

RSpec.describe User, type: :model do
  let(:user) { build(:user) }

  it 'is valid with valid attributes' do
    expect(user).to be_valid
  end

  it 'is invalid with incorrect email format' do
    user.email = 'fail@'
    expect(user).not_to be_valid
  end

  it 'is invalid with incorrect unconfirmed email format' do
    user.unconfirmed_email = 'fail.com'
    expect(user).not_to be_valid
  end

  it 'is invalid with no username' do
    user.username = nil
    expect(user).not_to be_valid
  end

  it 'is invalid with no password' do
    user.password = nil
    user.password_confirmation = nil
    expect(user).not_to be_valid
  end

  it 'is invalid with a long email' do
    user.email = 'a' * 101
    expect(user).not_to be_valid
  end

  it 'is invalid with a long username' do
    user.username = 'a' * 101
    expect(user).not_to be_valid
  end

  it 'is invalid with a short password' do
    user.password = 'a' * 9
    expect(user).not_to be_valid
  end

  it 'is invalid with a long password' do
    user.password = 'a' * 73
    expect(user).not_to be_valid
  end

  it 'has an authentication token after saving' do
    user.save
    user.reload
    expect(user.auth_token).not_to be_nil
  end

  it 'has an email confirmation token after saving' do
    user.save
    user.reload
    expect(user.email_confirmation_token).not_to be_nil
  end
end
