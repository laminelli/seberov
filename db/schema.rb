# encoding: UTF-8
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

ActiveRecord::Schema.define(version: 20150702114332) do

  create_table "refinery_apartment_floors", force: :cascade do |t|
    t.integer  "apartment_id",    null: false
    t.integer  "floor_number",    null: false
    t.float    "corridor_area"
    t.float    "wc_area"
    t.float    "workroom_area"
    t.float    "kitchen_area"
    t.float    "chamber1_area"
    t.float    "bathroom_area"
    t.float    "staircase_area"
    t.float    "room1_area"
    t.float    "room2_area"
    t.float    "room3_area"
    t.float    "room4_area"
    t.float    "room5_area"
    t.datetime "created_at"
    t.datetime "updated_at"
    t.float    "chamber2_area"
    t.float    "chamber3_area"
    t.float    "vestibule_area"
    t.float    "cloakroom1_area"
    t.float    "cloakroom2_area"
    t.float    "gallery_area"
  end

  add_index "refinery_apartment_floors", ["floor_number"], name: "index_refinery_apartment_floors_on_floor_number"

  create_table "refinery_apartments", force: :cascade do |t|
    t.string   "block"
    t.string   "unit_id"
    t.integer  "photo_id"
    t.integer  "floor"
    t.integer  "total_floors"
    t.string   "layout"
    t.float    "apartment_area"
    t.float    "balcony_terace_area"
    t.float    "front_yard_area"
    t.decimal  "price"
    t.integer  "position"
    t.string   "state"
    t.datetime "created_at"
    t.datetime "updated_at"
    t.integer  "parking_price"
  end

  create_table "refinery_images", force: :cascade do |t|
    t.string   "image_mime_type"
    t.string   "image_name"
    t.integer  "image_size"
    t.integer  "image_width"
    t.integer  "image_height"
    t.string   "image_uid"
    t.datetime "created_at"
    t.datetime "updated_at"
    t.string   "image_title"
    t.string   "image_alt"
  end

  create_table "refinery_page_part_translations", force: :cascade do |t|
    t.integer  "refinery_page_part_id", null: false
    t.string   "locale",                null: false
    t.datetime "created_at",            null: false
    t.datetime "updated_at",            null: false
    t.text     "body"
  end

  add_index "refinery_page_part_translations", ["locale"], name: "index_refinery_page_part_translations_on_locale"
  add_index "refinery_page_part_translations", ["refinery_page_part_id"], name: "index_refinery_page_part_translations_on_refinery_page_part_id"

  create_table "refinery_page_parts", force: :cascade do |t|
    t.integer  "refinery_page_id"
    t.string   "title"
    t.text     "body"
    t.integer  "position"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  add_index "refinery_page_parts", ["id"], name: "index_refinery_page_parts_on_id"
  add_index "refinery_page_parts", ["refinery_page_id"], name: "index_refinery_page_parts_on_refinery_page_id"

  create_table "refinery_page_translations", force: :cascade do |t|
    t.integer  "refinery_page_id", null: false
    t.string   "locale",           null: false
    t.datetime "created_at",       null: false
    t.datetime "updated_at",       null: false
    t.string   "title"
    t.string   "custom_slug"
    t.string   "menu_title"
    t.string   "slug"
  end

  add_index "refinery_page_translations", ["locale"], name: "index_refinery_page_translations_on_locale"
  add_index "refinery_page_translations", ["refinery_page_id"], name: "index_refinery_page_translations_on_refinery_page_id"

  create_table "refinery_pages", force: :cascade do |t|
    t.integer  "parent_id"
    t.string   "path"
    t.string   "slug"
    t.string   "custom_slug"
    t.boolean  "show_in_menu",        default: true
    t.string   "link_url"
    t.string   "menu_match"
    t.boolean  "deletable",           default: true
    t.boolean  "draft",               default: false
    t.boolean  "skip_to_first_child", default: false
    t.integer  "lft"
    t.integer  "rgt"
    t.integer  "depth"
    t.string   "view_template"
    t.string   "layout_template"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  add_index "refinery_pages", ["depth"], name: "index_refinery_pages_on_depth"
  add_index "refinery_pages", ["id"], name: "index_refinery_pages_on_id"
  add_index "refinery_pages", ["lft"], name: "index_refinery_pages_on_lft"
  add_index "refinery_pages", ["parent_id"], name: "index_refinery_pages_on_parent_id"
  add_index "refinery_pages", ["rgt"], name: "index_refinery_pages_on_rgt"

  create_table "refinery_resources", force: :cascade do |t|
    t.string   "file_mime_type"
    t.string   "file_name"
    t.integer  "file_size"
    t.string   "file_uid"
    t.string   "file_ext"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  create_table "refinery_roles", force: :cascade do |t|
    t.string "title"
  end

  create_table "refinery_roles_users", id: false, force: :cascade do |t|
    t.integer "user_id"
    t.integer "role_id"
  end

  add_index "refinery_roles_users", ["role_id", "user_id"], name: "index_refinery_roles_users_on_role_id_and_user_id"
  add_index "refinery_roles_users", ["user_id", "role_id"], name: "index_refinery_roles_users_on_user_id_and_role_id"

  create_table "refinery_user_plugins", force: :cascade do |t|
    t.integer "user_id"
    t.string  "name"
    t.integer "position"
  end

  add_index "refinery_user_plugins", ["name"], name: "index_refinery_user_plugins_on_name"
  add_index "refinery_user_plugins", ["user_id", "name"], name: "index_refinery_user_plugins_on_user_id_and_name", unique: true

  create_table "refinery_users", force: :cascade do |t|
    t.string   "username",               null: false
    t.string   "email",                  null: false
    t.string   "encrypted_password",     null: false
    t.datetime "current_sign_in_at"
    t.datetime "last_sign_in_at"
    t.string   "current_sign_in_ip"
    t.string   "last_sign_in_ip"
    t.integer  "sign_in_count"
    t.datetime "remember_created_at"
    t.string   "reset_password_token"
    t.datetime "reset_password_sent_at"
    t.datetime "created_at"
    t.datetime "updated_at"
    t.string   "slug"
    t.string   "full_name"
  end

  add_index "refinery_users", ["id"], name: "index_refinery_users_on_id"
  add_index "refinery_users", ["slug"], name: "index_refinery_users_on_slug"

  create_table "seo_meta", force: :cascade do |t|
    t.integer  "seo_meta_id"
    t.string   "seo_meta_type"
    t.string   "browser_title"
    t.text     "meta_description"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  add_index "seo_meta", ["id"], name: "index_seo_meta_on_id"
  add_index "seo_meta", ["seo_meta_id", "seo_meta_type"], name: "id_type_index_on_seo_meta"

end
