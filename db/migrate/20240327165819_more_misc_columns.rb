# frozen_string_literal: true

class MoreMiscColumns < ActiveRecord::Migration[7.1]
  def change
    add_column :locations, :subtitle, :string
    add_column :items, :description, :string
  end
end
