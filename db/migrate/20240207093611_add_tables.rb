class AddTables < ActiveRecord::Migration[7.1]
  def change
    create_table :zones do |t|
      t.string :name, null: false, index: { unique: true }

      t.timestamps
    end

    create_table :monsters do |t|
      t.references :zone, null: false, index: true

      t.string :name, null: false, index: { unique: true }
      t.integer :level, null: false
      t.boolean :elite, null: false, default: false
      t.boolean :named, null: false, default: false

      t.timestamps
    end

    create_table :items do |t|
      t.references :monster, null: false, index: true

      t.string :name, null: false, index: { unique: true }
      t.integer :vendor_copper
      t.decimal :weight, null: false

      t.boolean :no_trade, null: false, default: false
      t.boolean :soulbound, null: false, default: false

      t.timestamps
    end

    create_table :npcs do |t|
      t.references :zone, null: false, index: true

      t.string :name, null: false, index: { unique: true }

      t.timestamps
    end

    create_table :quest_objectives do |t|
      t.references :quest, null: false, index: true

      t.string :text, null: false

      t.references :item
      t.integer :item_amount

      t.timestamps
    end

    create_table :quests do |t|
      t.references :giver, null: false, foreign_key: { to_table: :npcs }
      t.references :dropped_as, foreign_key: { to_table: :items }

      t.references :receiver, foreign_key: { to_table: :npcs }

      t.string :name, null: false, index: { unique: true }
      t.string :text, null: false

      t.integer :reward_xp, null: false, default: 0
      t.integer :reward_copper, null: false, default: 0
      t.decimal :reward_standing, null: false, default: 0

      t.timestamps
    end
  end
end
