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

ActiveRecord::Schema[7.1].define(version: 2024_02_09_084439) do
  # These are extensions that must be enabled in order to support this database
  enable_extension "plpgsql"

  create_table "items", force: :cascade do |t|
    t.bigint "patch_id", null: false
    t.string "name", null: false
    t.integer "buy_price"
    t.integer "sell_price"
    t.decimal "weight", null: false
    t.integer "required_level"
    t.string "category"
    t.string "slot"
    t.jsonb "stats", default: {}
    t.jsonb "classes", default: []
    t.jsonb "attrs", default: []
    t.datetime "discarded_at"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["attrs"], name: "index_items_on_attrs"
    t.index ["classes"], name: "index_items_on_classes"
    t.index ["discarded_at"], name: "index_items_on_discarded_at"
    t.index ["name"], name: "index_items_on_name", unique: true
    t.index ["patch_id"], name: "index_items_on_patch_id"
    t.index ["stats"], name: "index_items_on_stats"
  end

  create_table "items_monsters", id: false, force: :cascade do |t|
    t.bigint "item_id", null: false
    t.bigint "monster_id", null: false
    t.index ["item_id", "monster_id"], name: "index_items_monsters_on_item_id_and_monster_id", unique: true
    t.index ["monster_id", "item_id"], name: "index_items_monsters_on_monster_id_and_item_id"
  end

  create_table "items_npcs", id: false, force: :cascade do |t|
    t.bigint "item_id", null: false
    t.bigint "npc_id", null: false
    t.index ["item_id", "npc_id"], name: "index_items_npcs_on_item_id_and_npc_id", unique: true
    t.index ["npc_id", "item_id"], name: "index_items_npcs_on_npc_id_and_item_id"
  end

  create_table "locations", force: :cascade do |t|
    t.bigint "zone_id", null: false
    t.string "name", null: false
    t.string "category", null: false
    t.decimal "loc_x"
    t.decimal "loc_y"
    t.decimal "loc_z"
    t.datetime "discarded_at"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["discarded_at"], name: "index_locations_on_discarded_at"
    t.index ["loc_x", "loc_y"], name: "index_locations_on_loc_x_and_loc_y"
    t.index ["name"], name: "index_locations_on_name", unique: true
    t.index ["zone_id"], name: "index_locations_on_zone_id"
  end

  create_table "monsters", force: :cascade do |t|
    t.bigint "patch_id", null: false
    t.bigint "location_id", null: false
    t.string "name", null: false
    t.integer "level", null: false
    t.boolean "elite", default: false, null: false
    t.boolean "named", default: false, null: false
    t.decimal "loc_x"
    t.decimal "loc_y"
    t.decimal "loc_z"
    t.datetime "discarded_at"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["discarded_at"], name: "index_monsters_on_discarded_at"
    t.index ["loc_x", "loc_y"], name: "index_monsters_on_loc_x_and_loc_y"
    t.index ["location_id"], name: "index_monsters_on_location_id"
    t.index ["name"], name: "index_monsters_on_name", unique: true
    t.index ["patch_id"], name: "index_monsters_on_patch_id"
  end

  create_table "npcs", force: :cascade do |t|
    t.bigint "patch_id", null: false
    t.bigint "location_id", null: false
    t.string "name", null: false
    t.string "subtitle"
    t.boolean "vendor", default: false, null: false
    t.decimal "loc_x"
    t.decimal "loc_y"
    t.decimal "loc_z"
    t.datetime "discarded_at"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["discarded_at"], name: "index_npcs_on_discarded_at"
    t.index ["loc_x", "loc_y"], name: "index_npcs_on_loc_x_and_loc_y"
    t.index ["location_id"], name: "index_npcs_on_location_id"
    t.index ["name"], name: "index_npcs_on_name", unique: true
    t.index ["patch_id"], name: "index_npcs_on_patch_id"
    t.index ["subtitle"], name: "index_npcs_on_subtitle"
  end

  create_table "patches", force: :cascade do |t|
    t.string "version", null: false
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["version"], name: "index_patches_on_version", unique: true
  end

  create_table "quest_objectives", force: :cascade do |t|
    t.bigint "patch_id", null: false
    t.bigint "quest_id", null: false
    t.bigint "monster_id"
    t.bigint "item_id"
    t.integer "amount"
    t.string "text"
    t.datetime "discarded_at"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["discarded_at"], name: "index_quest_objectives_on_discarded_at"
    t.index ["item_id"], name: "index_quest_objectives_on_item_id"
    t.index ["monster_id"], name: "index_quest_objectives_on_monster_id"
    t.index ["patch_id"], name: "index_quest_objectives_on_patch_id"
    t.index ["quest_id"], name: "index_quest_objectives_on_quest_id"
  end

  create_table "quest_rewards", force: :cascade do |t|
    t.bigint "patch_id", null: false
    t.bigint "quest_id", null: false
    t.string "skill"
    t.bigint "item_id"
    t.boolean "copper"
    t.boolean "standing"
    t.boolean "xp"
    t.decimal "amount"
    t.string "text"
    t.datetime "discarded_at"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["copper"], name: "index_quest_rewards_on_copper"
    t.index ["discarded_at"], name: "index_quest_rewards_on_discarded_at"
    t.index ["item_id"], name: "index_quest_rewards_on_item_id"
    t.index ["patch_id"], name: "index_quest_rewards_on_patch_id"
    t.index ["quest_id"], name: "index_quest_rewards_on_quest_id"
    t.index ["skill"], name: "index_quest_rewards_on_skill"
    t.index ["standing"], name: "index_quest_rewards_on_standing"
  end

  create_table "quests", force: :cascade do |t|
    t.bigint "patch_id", null: false
    t.bigint "prereq_quest_id"
    t.bigint "giver_id"
    t.bigint "dropped_as_id"
    t.bigint "receiver_id"
    t.string "name", null: false
    t.string "text", null: false
    t.datetime "discarded_at"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["discarded_at"], name: "index_quests_on_discarded_at"
    t.index ["dropped_as_id"], name: "index_quests_on_dropped_as_id"
    t.index ["giver_id"], name: "index_quests_on_giver_id"
    t.index ["name"], name: "index_quests_on_name", unique: true
    t.index ["patch_id"], name: "index_quests_on_patch_id"
    t.index ["prereq_quest_id"], name: "index_quests_on_prereq_quest_id"
    t.index ["receiver_id"], name: "index_quests_on_receiver_id"
  end

  create_table "resources", force: :cascade do |t|
    t.bigint "patch_id", null: false
    t.bigint "location_id", null: false
    t.string "name", null: false
    t.string "resource", null: false
    t.string "subresource"
    t.string "size", null: false
    t.decimal "loc_x", null: false
    t.decimal "loc_y", null: false
    t.decimal "loc_z", null: false
    t.datetime "discarded_at"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["discarded_at"], name: "index_resources_on_discarded_at"
    t.index ["loc_x", "loc_y"], name: "index_resources_on_loc_x_and_loc_y"
    t.index ["location_id"], name: "index_resources_on_location_id"
    t.index ["name"], name: "index_resources_on_name"
    t.index ["patch_id"], name: "index_resources_on_patch_id"
    t.index ["resource"], name: "index_resources_on_resource"
    t.index ["size"], name: "index_resources_on_size"
    t.index ["subresource"], name: "index_resources_on_subresource"
  end

  create_table "versions", force: :cascade do |t|
    t.string "item_type", null: false
    t.bigint "item_id", null: false
    t.string "event", null: false
    t.string "whodunnit"
    t.text "object"
    t.datetime "created_at"
    t.text "object_changes"
    t.index ["item_type", "item_id"], name: "index_versions_on_item_type_and_item_id"
  end

  create_table "zones", force: :cascade do |t|
    t.bigint "patch_id", null: false
    t.string "name", null: false
    t.datetime "discarded_at"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["discarded_at"], name: "index_zones_on_discarded_at"
    t.index ["name"], name: "index_zones_on_name", unique: true
    t.index ["patch_id"], name: "index_zones_on_patch_id"
  end

  add_foreign_key "quests", "items", column: "dropped_as_id"
  add_foreign_key "quests", "npcs", column: "giver_id"
  add_foreign_key "quests", "npcs", column: "receiver_id"
  add_foreign_key "quests", "quests", column: "prereq_quest_id"
end
