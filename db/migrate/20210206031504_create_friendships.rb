# frozen_string_literal: true

class CreateFriendships < ActiveRecord::Migration[6.1]
  def change
    create_table :friendships, id: false do |t|
      t.ksuid_binary :id, primary_key: true

      t.references :user, foreign_key: true, type: 'blob(20)'
      t.references :friend, foreign_key: false, type: 'blob(20)'
      t.column :status, :integer

      t.timestamps
    end
    add_foreign_key :friendships, :users, column: :friend_id
  end
end
