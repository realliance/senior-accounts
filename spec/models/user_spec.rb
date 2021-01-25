# frozen_string_literal: true

require 'rails_helper'

RSpec.describe User, type: :model do
  subject(:user) do
    described_class.new(username: 'wilson', email: 'wilson@gmail.com', password: 'password', rating: 2000,
                        resources: 100)
  end

    it 'Can be created' do
      expect(user).to be_valid
    end

    it 'Username should be present' do
      expect(user.username).not_to eq nil
    end

    it 'Email should be present' do
      expect(user.email).not_to eq nil
    end

    it 'Password should be present' do
      expect(user.password).not_to eq nil
    end
end
