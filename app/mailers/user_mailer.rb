# frozen_string_literal: true

class UserMailer < ApplicationMailer
  def email_confirmation(user, email)
    @user = user
    mail to: email, subject: 'Wizard Connect 3: Email Confirmation'
  end
end
