# frozen_string_literal: true

class UserMailer < ApplicationMailer
  def email_confirmation(user, email)
    @user = user
    mail to: email, subject: 'Email confirmation'
  end
end
