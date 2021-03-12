# frozen_string_literal: true

json.id @user.id.to_s
json.extract! @user, :username

json.friends do
  json.array! @user.friends, :username
end

json.friends_pending do
  json.array! @user.friends_pending, :username
end

json.friends_awaiting do
  json.array! @user.friends_awaiting, :username
end
