# frozen_string_literal: true

json.id @user.id.to_s
json.extract! @user, :username

json.friends do
  json.array! @user.friends, :username
end

json.pending_requests do
  json.array! @user.pending_requests, :username
end

json.received_requests do
  json.array! @user.received_requests, :username
end
