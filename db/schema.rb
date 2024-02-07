# This file is auto-generated from the current state of the database. Instead
# of editing this file, please use the migrations feature of Active Record to
# incrementally modify your database, and then regenerate this schema definition.
#
# This file is the source Rails uses to define your schema when running `bin/rails
# db:schema:load`. When creating a new database, `bin/rails db:schema:load` tends to
# be faster and is potentially less error prone than running all of your
# migrations from scratch. Old migrations may fail to apply correctly if those
# migrations use external dependencies or application code.
#
# It's strongly recommended that you check this file into your version control system.

ActiveRecord::Schema[7.1].define(version: 2024_02_07_093611) do
  # These are extensions that must be enabled in order to support this database
  enable_extension "plpgsql"

  create_table "items", force: :cascade do |t|
    t.bigint "monster_id", null: false
    t.bigint "quest_id"
    t.string "name", null: false
    t.integer "vendor_copper"
    t.decimal "weight", null: false
    t.string "category"
    t.string "classes", default: [], array: true
    t.string "slot"
    t.boolean "no_trade", default: false, null: false
    t.boolean "soulbound", default: false, null: false
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["monster_id"], name: "index_items_on_monster_id"
    t.index ["name"], name: "index_items_on_name", unique: true
    t.index ["quest_id"], name: "index_items_on_quest_id"
  end

  create_table "monsters", force: :cascade do |t|
    t.bigint "zone_id", null: false
    t.string "name", null: false
    t.integer "level", null: false
    t.boolean "elite", default: false, null: false
    t.boolean "named", default: false, null: false
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["name"], name: "index_monsters_on_name", unique: true
    t.index ["zone_id"], name: "index_monsters_on_zone_id"
  end

  create_table "npcs", force: :cascade do |t|
    t.bigint "zone_id", null: false
    t.string "name", null: false
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["name"], name: "index_npcs_on_name", unique: true
    t.index ["zone_id"], name: "index_npcs_on_zone_id"
  end

  create_table "quest_objectives", force: :cascade do |t|
    t.bigint "quest_id", null: false
    t.string "text", null: false
    t.bigint "item_id"
    t.integer "item_amount"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["item_id"], name: "index_quest_objectives_on_item_id"
    t.index ["quest_id"], name: "index_quest_objectives_on_quest_id"
  end

  create_table "quests", force: :cascade do |t|
    t.bigint "giver_id", null: false
    t.bigint "dropped_as_id"
    t.bigint "receiver_id"
    t.string "name", null: false
    t.string "text", null: false
    t.integer "reward_xp", default: 0, null: false
    t.integer "reward_copper", default: 0, null: false
    t.decimal "reward_standing", default: "0.0", null: false
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["dropped_as_id"], name: "index_quests_on_dropped_as_id"
    t.index ["giver_id"], name: "index_quests_on_giver_id"
    t.index ["name"], name: "index_quests_on_name", unique: true
    t.index ["receiver_id"], name: "index_quests_on_receiver_id"
  end

  create_table "zones", force: :cascade do |t|
    t.string "name", null: false
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["name"], name: "index_zones_on_name", unique: true
  end

  add_foreign_key "quests", "items", column: "dropped_as_id"
  add_foreign_key "quests", "npcs", column: "giver_id"
  add_foreign_key "quests", "npcs", column: "receiver_id"
end
