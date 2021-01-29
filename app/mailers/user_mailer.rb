# frozen_string_literal: true

class UserMailer < ApplicationMailer
  def account_activation(user, email)
    @user = user
    mail to: email, subject: 'Email confirmation'
  end
end
