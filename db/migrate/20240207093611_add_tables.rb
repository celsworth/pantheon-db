# frozen_string_literal: true

class AddTables < ActiveRecord::Migration[7.1]
  def change
    create_table :patches do |t|
      t.string :version, null: false, index: { unique: true }

      t.timestamps
    end

    create_table :zones do |t|
      t.references :patch, null: false, index: true

      t.string :name, null: false, index: { unique: true }

      t.datetime :discarded_at, index: true
      t.timestamps
    end

    create_table :resources do |t|
      t.references :patch, null: false, index: true

      t.references :zone, null: false, index: true

      t.string :name, null: false # Large Pine Tree
      t.string :size, null: false # normal / large / huge
      t.string :category, null: false # tree / metal / ?
      t.integer :tier, null: false # 2

      t.decimal :loc_x
      t.decimal :loc_y
      t.decimal :loc_z

      t.datetime :discarded_at, index: true
      t.timestamps
    end

    create_table :monsters do |t|
      t.references :patch, null: false, index: true

      t.references :zone, null: false, index: true

      t.string :name, null: false, index: { unique: true }
      t.integer :level, null: false
      t.boolean :elite, null: false, default: false
      t.boolean :named, null: false, default: false

      t.decimal :loc_x
      t.decimal :loc_y
      t.decimal :loc_z

      t.datetime :discarded_at, index: true
      t.timestamps
    end

    create_table :items do |t|
      t.references :patch, null: false, index: true

      t.string :name, null: false, index: { unique: true }
      t.integer :buy_price
      t.integer :sell_price
      t.decimal :weight, null: false
      t.integer :required_level

      t.string :category
      t.string :slot

      t.jsonb :stats, default: {}, index: :gin
      t.jsonb :classes, default: [], index: :gin
      t.jsonb :attrs, default: [], index: :gin

      t.datetime :discarded_at, index: true
      t.timestamps
    end

    create_table :npcs do |t|
      t.references :patch, null: false, index: true

      t.references :zone, null: false, index: true

      t.string :name, null: false, index: { unique: true }
      t.string :subtitle, index: true

      t.boolean :vendor, null: false, default: false

      t.decimal :loc_x
      t.decimal :loc_y
      t.decimal :loc_z

      t.datetime :discarded_at, index: true
      t.timestamps
    end

    create_table :quest_objectives do |t|
      t.references :patch, null: false, index: true

      t.references :quest, null: false, index: true

      t.references :monster, index: true
      t.references :item, index: true
      t.integer :amount

      t.string :text

      t.datetime :discarded_at, index: true
      t.timestamps
    end

    create_table :quest_rewards do |t|
      t.references :patch, null: false, index: true

      t.references :quest, null: false, index: true

      t.string :skill, index: true
      t.references :item, index: true
      t.boolean :copper, index: true
      t.boolean :standing, index: true
      t.boolean :xp
      t.decimal :amount

      t.string :text

      t.datetime :discarded_at, index: true
      t.timestamps
    end

    create_table :quests do |t|
      t.references :patch, null: false, index: true

      t.references :prereq_quest, foreign_key: { to_table: :quests }, index: true

      t.references :giver, foreign_key: { to_table: :npcs }, index: true
      t.references :dropped_as, foreign_key: { to_table: :items }, index: true

      t.references :receiver, foreign_key: { to_table: :npcs }, index: true

      t.string :name, null: false, index: { unique: true }
      t.string :text, null: false

      t.datetime :discarded_at, index: true
      t.timestamps
    end

    create_join_table :items, :monsters do |t|
      t.index %i[item_id monster_id], unique: true
      t.index %i[monster_id item_id]
    end

    create_join_table :items, :npcs do |t|
      t.index %i[item_id npc_id], unique: true
      t.index %i[npc_id item_id]
    end
  end
end
