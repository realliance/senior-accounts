# frozen_string_literal: true

class AddPasswordRecoveryTokenToUsers < ActiveRecord::Migration[6.1]
  def change
    add_column :users, :password_recovery_token, :string
    add_index :users, :password_recovery_token, unique: true
  end
end
