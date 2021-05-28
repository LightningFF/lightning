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

ActiveRecord::Schema.define(version: 2021_05_28_164611) do

  create_table "lightning_feature_opt_ins", force: :cascade do |t|
    t.integer "feature_id", null: false
    t.integer "entity_id", null: false
    t.string "entity_type", null: false
    t.datetime "created_at", precision: 6, null: false
    t.datetime "updated_at", precision: 6, null: false
    t.index ["entity_id", "entity_type"], name: "index_lightning_feature_opt_ins_on_entity_id_and_entity_type"
    t.index ["feature_id", "entity_id", "entity_type"], name: "opt_in_index", unique: true
  end

  create_table "lightning_features", force: :cascade do |t|
    t.string "key", null: false
    t.text "description"
    t.integer "state", default: 0, null: false
    t.datetime "created_at", precision: 6, null: false
    t.datetime "updated_at", precision: 6, null: false
    t.index ["key"], name: "index_lightning_features_on_key", unique: true
  end

  create_table "users", force: :cascade do |t|
    t.string "name"
    t.datetime "created_at", precision: 6, null: false
    t.datetime "updated_at", precision: 6, null: false
  end

  create_table "workspaces", force: :cascade do |t|
    t.string "name"
    t.datetime "created_at", precision: 6, null: false
    t.datetime "updated_at", precision: 6, null: false
  end

end
