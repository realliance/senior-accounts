# frozen_string_literal: true

require 'rails_helper'

RSpec.describe UserMailer, type: :mailer do
  let(:user) { build(:unconfirmed_user) }

  describe 'email_confirmation' do
    let(:mail) { described_class.email_confirmation(user, user.unconfirmed_email) }

    it 'renders the headers' do
      expect(mail.subject).to eq('Wizard Connect 3: Email Confirmation')
      expect(mail.to).to eq([user.unconfirmed_email])
      expect(mail.from).to eq(['from@example.com'])
    end

    it 'renders a body' do
      expect(mail.body.encoded).not_to be_empty
    end

    it 'assigns @username' do
      expect(mail.body.encoded).to match(user.username)
    end

    it 'assigns @confirm_url' do
      expect(mail.body.encoded).to match(a_string_including("/confirm/#{user.email_confirmation_token}"))
    end
  end
end
