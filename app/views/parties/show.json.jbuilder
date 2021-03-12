# frozen_string_literal: true

json.id @user.id.to_s
json.extract! @user, :username

json.invitations_pending do
  json.array! @user.invitations_pending, :username
end

json.invitations_received do
  json.array! @user.invitations_received, :username
end

json.party do
  json.array! @user.party_members, :username
end
