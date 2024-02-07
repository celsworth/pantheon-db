class AddTables < ActiveRecord::Migration[7.1]
  def change
    create_table :zones do |t|
      t.string :name, null: false
    end

    create_table :monsters do |t|
      t.references :zone, null: false

      t.string :name, null: false
      t.integer :level, null: false
      t.boolean :elite, null: false, default: false
      t.boolean :named, null: false, default: false
    end

    create_table :items do |t|
      t.references :monster, null: false

      t.string :name, null: false
      t.integer :vendor_copper
      t.decimal :weight, null: false
    end
  end
end
