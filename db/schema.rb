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

ActiveRecord::Schema.define(version: 20150404130831) do

  create_table "beds", force: true do |t|
    t.string   "name"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  create_table "cities", force: true do |t|
    t.string "name"
  end

  create_table "history_records", force: true do |t|
    t.string   "message"
    t.integer  "listing_id"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  add_index "history_records", ["listing_id"], name: "index_history_records_on_listing_id"

  create_table "listing_neighborhoods", force: true do |t|
    t.integer "listing_id"
    t.integer "neighborhood_id"
  end

  create_table "listing_types", force: true do |t|
    t.string   "name"
    t.string   "string"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  create_table "listings", force: true do |t|
    t.integer  "agent_id"
    t.string   "main_photo",          default: "wzupztbtjzhe0fi3fpda.jpg"
    t.string   "street_address"
    t.string   "zip_code"
    t.decimal  "price"
    t.integer  "size"
    t.text     "description"
    t.datetime "created_at"
    t.datetime "updated_at"
    t.integer  "user_id"
    t.integer  "full_baths_no"
    t.integer  "half_baths_no"
    t.integer  "status_id"
    t.integer  "bed_id"
    t.integer  "neighborhood_id"
    t.integer  "property_type_id"
    t.integer  "listing_type_id"
    t.integer  "city_id"
    t.string   "unit_no"
    t.boolean  "dishwasher",          default: false
    t.boolean  "backyard",            default: false
    t.boolean  "balcony",             default: false
    t.boolean  "elevator",            default: false
    t.boolean  "laundry_in_building", default: false
    t.boolean  "laundry_in_unit",     default: false
    t.boolean  "live_in_super",       default: false
    t.boolean  "absentee_landlord",   default: false
    t.boolean  "walk_up",             default: false
    t.boolean  "no_pets",             default: false
    t.boolean  "cats",                default: false
    t.boolean  "dogs",                default: false
    t.boolean  "approved_pets_only",  default: false
    t.boolean  "heat_and_hot_water",  default: false
    t.boolean  "gas",                 default: false
    t.boolean  "all_utilities",       default: false
    t.boolean  "none",                default: false
    t.date     "available_date"
    t.string   "landlord"
    t.boolean  "parking_available",   default: false
    t.boolean  "storage_available",   default: false
  end

  add_index "listings", ["available_date"], name: "index_listings_on_available_date"
  add_index "listings", ["bed_id"], name: "index_listings_on_bed_id"
  add_index "listings", ["city_id"], name: "index_listings_on_city_id"
  add_index "listings", ["listing_type_id"], name: "index_listings_on_listing_type_id"
  add_index "listings", ["neighborhood_id"], name: "index_listings_on_neighborhood_id"
  add_index "listings", ["property_type_id"], name: "index_listings_on_property_type_id"
  add_index "listings", ["user_id"], name: "index_listings_on_user_id"

  create_table "neighborhoods", force: true do |t|
    t.string "name"
  end

  create_table "property_photos", force: true do |t|
    t.string   "photo_url"
    t.datetime "created_at"
    t.datetime "updated_at"
    t.integer  "listing_id"
  end

  add_index "property_photos", ["listing_id"], name: "index_property_photos_on_listing_id"

  create_table "property_types", force: true do |t|
    t.string   "name"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  create_table "statuses", force: true do |t|
    t.string   "name"
    t.datetime "created_at"
    t.datetime "updated_at"
    t.boolean  "is_for_rentals", default: false
  end

  create_table "users", force: true do |t|
    t.string   "name"
    t.string   "login"
    t.datetime "created_at"
    t.datetime "updated_at"
    t.string   "email"
    t.string   "password_digest"
    t.string   "remember_token"
    t.boolean  "admin",              default: false
    t.string   "avatar"
    t.string   "phone"
    t.string   "fax"
    t.text     "biography"
    t.string   "address"
    t.string   "license_no"
    t.string   "social_security_no"
    t.float    "commision_split"
  end

  add_index "users", ["email"], name: "index_users_on_email", unique: true
  add_index "users", ["remember_token"], name: "index_users_on_remember_token"

end
