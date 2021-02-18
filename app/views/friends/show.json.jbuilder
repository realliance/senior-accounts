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

json.pending_invitations do
  json.array! @user.pending_invitations, :username
end

json.received_invitations do
  json.array! @user.received_invitations, :username
end

json.party do
  json.array! @user.party_members, :username
end
