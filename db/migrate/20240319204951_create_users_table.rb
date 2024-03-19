# frozen_string_literal: true

class CreateUsersTable < ActiveRecord::Migration[7.1]
  def change
    create_table :users do |t|
      t.string :username, null: false, index: { unique: true }

      t.string :role, null: false

      t.timestamps
    end
  end
end
