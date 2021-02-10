# frozen_string_literal: true

json.id @user.id.to_s
json.extract! @user, :username

json.friends do
  json.array! @user.friends, :username
end

json.pending_friends do
  json.array! @user.pending_friends, :username
end

json.requested_friends do
  json.array! @user.requested_friends, :username
end
