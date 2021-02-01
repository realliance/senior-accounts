# frozen_string_literal: true

json.id @user.id.to_s
json.extract! @user, :email, :username
