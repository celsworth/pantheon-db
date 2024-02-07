class AddItems < ActiveRecord::Migration[7.1]
  def change
    create_table :items
  end
end
