# frozen_string_literal: true

class CreateFriendships < ActiveRecord::Migration[6.1]
  def change
    create_table :friendships, id: false do |t|
      t.references :sent_by, foreign_key: { to_table: :users }, type: 'blob(20)'
      t.references :sent_to, foreign_key: { to_table: :users }, type: 'blob(20)'
      t.column :status, :integer

      t.timestamps
    end
  end
end
