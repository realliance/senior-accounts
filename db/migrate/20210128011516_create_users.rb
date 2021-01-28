# frozen_string_literal: true

class CreateUsers < ActiveRecord::Migration[6.1]
  def change
    create_table :users, id: false do |t|
      t.binary :id, limit: 16, primary_key: true

      t.string :username, null: false
      t.index :username, unique: true

      t.string :email, null: false
      t.index :email, unique: true

      t.string :password_digest

      t.timestamps
    end
  end
end
