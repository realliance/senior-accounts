# frozen_string_literal: true

class CreateFriends < ActiveRecord::Migration[6.1]
  def change
    create_table :friends, id: false do |t|
      t.ksuid_binary :id, primary_key: true

      t.references :sent_by, foreign_key: { to_table: :users }, type: 'blob(20)'
      t.references :sent_to, foreign_key: { to_table: :users }, type: 'blob(20)'
      t.column :status, :integer
      t.column :invitation, :integer

      t.timestamps
    end
  end
end
