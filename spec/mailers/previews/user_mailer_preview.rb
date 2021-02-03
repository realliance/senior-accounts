# frozen_string_literal: true

class UserMailerPreview < ActionMailer::Preview
  def email_confirmation
    UserMailer.email_confirmation(User.first)
  end

  def password_recovery
    UserMailer.password_recovery(User.first)
  end
end
