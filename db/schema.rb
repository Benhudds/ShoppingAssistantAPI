# This file is auto-generated from the current state of the database. Instead
# of editing this file, please use the migrations feature of Active Record to
# incrementally modify your database, and then regenerate this schema definition.
#
# Note that this schema.rb definition is the authoritative source for your
# database schema. If you need to create the application database on another
# system, you should be using db:schema:load, not running all the migrations
# from scratch. The latter is a flawed and unsustainable approach (the more migrations
# you'll amass, the slower it'll run and the greater likelihood for issues).
#
# It's strongly recommended that you check this file into your version control system.

ActiveRecord::Schema.define(version: 20180113223437) do

  create_table "ipls", force: :cascade do |t|
    t.float "price"
    t.string "item"
    t.integer "location_id"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.string "measure"
    t.float "quantity"
    t.index ["location_id"], name: "index_ipls_on_location_id"
  end

  create_table "iqps", force: :cascade do |t|
    t.string "item"
    t.integer "quantity"
    t.integer "slist_id"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.string "measure"
    t.index ["slist_id"], name: "index_iqps_on_slist_id"
  end

  create_table "items", force: :cascade do |t|
    t.string "name"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
  end

  create_table "listowners", force: :cascade do |t|
    t.integer "slist_id"
    t.integer "user_id"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["slist_id"], name: "index_listowners_on_slist_id"
    t.index ["user_id"], name: "index_listowners_on_user_id"
  end

  create_table "locationqueries", force: :cascade do |t|
    t.float "lat"
    t.float "lng"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
  end

  create_table "locations", force: :cascade do |t|
    t.string "name"
    t.float "lat"
    t.float "lng"
    t.string "vicinity"
    t.string "googleid"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
  end

  create_table "slists", force: :cascade do |t|
    t.string "name"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
  end

  create_table "tescoqueries", force: :cascade do |t|
    t.string "query"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
  end

  create_table "users", force: :cascade do |t|
    t.string "name"
    t.string "email", null: false
    t.string "password_digest"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["email"], name: "index_users_on_email", unique: true
  end

end
