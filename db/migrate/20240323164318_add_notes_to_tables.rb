# frozen_string_literal: true

class AddNotesToTables < ActiveRecord::Migration[7.1]
  def change
    add_column :items, :private_notes, :text
    add_column :items, :public_notes, :text

    add_column :locations, :private_notes, :text
    add_column :locations, :public_notes, :text

    add_column :monsters, :private_notes, :text
    add_column :monsters, :public_notes, :text

    add_column :npcs, :private_notes, :text
    add_column :npcs, :public_notes, :text
  end
end
