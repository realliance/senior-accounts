# frozen_string_literal: true

require 'rails_helper'

RSpec.describe UserMailer, type: :mailer do
  let(:user) { build(:user) }

  describe 'email_confirmation' do
    let(:mail) { described_class.email_confirmation(user, user.email) }

    it 'renders the headers' do
      expect(mail.subject).to eq('Email confirmation')
      expect(mail.to).to eq([user.email])
      expect(mail.from).to eq(['from@example.com'])
    end

    it 'renders a body' do
      expect(mail.body.encoded).not_to be_empty
    end

    it 'assigns @name' do
      expect(mail.body.encoded).to match(user.username)
    end

    it 'assigns @confirm_url' do
      expect(mail.body.encoded).to match(a_string_including("/confirm/#{user.email_confirmation_token}"))
    end
  end
end
