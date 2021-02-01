# frozen_string_literal: true

class CreateUsers < ActiveRecord::Migration[6.1]
  def change
    create_table :users, id: false do |t|
      t.ksuid_binary :id, primary_key: true

      t.string :username, null: false
      t.index :username, unique: true

      t.string :email

      t.string :unconfirmed_email

      t.string :password_digest

      t.string :auth_token
      t.index :auth_token, unique: true

      t.string :email_confirmation_token
      t.index :email_confirmation_token, unique: true

      t.timestamps
    end
  end
end
