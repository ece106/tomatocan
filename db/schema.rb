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

ActiveRecord::Schema.define(version: 201309200000000) do

  # These are extensions that must be enabled in order to support this database
  enable_extension "plpgsql"

  create_table "books", force: true do |t|
    t.string   "title"
    t.text     "blurb"
    t.date     "releasedate"
    t.integer  "author_id"
    t.string   "genre"
    t.string   "fiftychar"
    t.float    "price"
    t.string   "bookpdf"
    t.string   "coverpic"
    t.string   "coverpicurl"
    t.datetime "created_at"
    t.datetime "updated_at"
    t.integer  "user_id"
    t.string   "bookmobi"
    t.string   "bookepub"
    t.string   "bookkobo"
    t.string   "bookaudio"
    t.text     "youtube1"
    t.text     "youtube2"
    t.string   "videodesc1"
    t.string   "videodesc2"
    t.string   "videodesc3"
  end

  create_table "events", force: true do |t|
    t.string   "name"
    t.datetime "start_at"
    t.datetime "end_at"
    t.datetime "created_at"
    t.datetime "updated_at"
    t.text     "desc"
    t.string   "address"
    t.integer  "user_id"
    t.float    "latitude"
    t.float    "longitude"
    t.integer  "group1id"
    t.integer  "group2id"
    t.integer  "group3id"
    t.integer  "usrid"
  end

  create_table "friendly_id_slugs", force: true do |t|
    t.string   "slug",                      null: false
    t.integer  "sluggable_id",              null: false
    t.string   "sluggable_type", limit: 50
    t.string   "scope"
    t.datetime "created_at"
  end

  add_index "friendly_id_slugs", ["slug", "sluggable_type", "scope"], name: "index_friendly_id_slugs_on_slug_and_sluggable_type_and_scope", unique: true, using: :btree
  add_index "friendly_id_slugs", ["slug", "sluggable_type"], name: "index_friendly_id_slugs_on_slug_and_sluggable_type", using: :btree
  add_index "friendly_id_slugs", ["sluggable_id"], name: "index_friendly_id_slugs_on_sluggable_id", using: :btree
  add_index "friendly_id_slugs", ["sluggable_type"], name: "index_friendly_id_slugs_on_sluggable_type", using: :btree

  create_table "groups", force: true do |t|
    t.string   "name"
    t.string   "address"
    t.float    "latitude"
    t.float    "longitude"
    t.integer  "user_id"
    t.text     "about"
    t.string   "grouppic"
    t.datetime "created_at"
    t.datetime "updated_at"
    t.integer  "grouptype"
    t.string   "permalink"
    t.string   "slug"
    t.string   "newsurl"
    t.string   "twitter"
    t.string   "facebook"
  end

  add_index "groups", ["slug"], name: "index_groups_on_slug", unique: true, using: :btree

  create_table "purchases", force: true do |t|
    t.integer  "author_id"
    t.integer  "book_id"
    t.string   "stripe_customer_token"
    t.integer  "plan_id"
    t.datetime "created_at"
    t.datetime "updated_at"
    t.string   "stripe_card_token"
    t.integer  "user_id"
    t.string   "bookfiletype"
  end

  create_table "reviews", force: true do |t|
    t.text     "blurb"
    t.integer  "user_id"
    t.integer  "book_id"
    t.integer  "star"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  create_table "rsvps", force: true do |t|
    t.integer "event_id"
    t.integer "user_id"
    t.integer "guests"
  end

  create_table "users", force: true do |t|
    t.string   "name"
    t.string   "email"
    t.text     "ustreamvid"
    t.text     "ustreamsocial"
    t.string   "twitter"
    t.string   "facebook"
    t.string   "pinterest"
    t.string   "youtube"
    t.string   "genre1"
    t.string   "genre2"
    t.string   "genre3"
    t.string   "blogurl"
    t.string   "profilepicurl"
    t.string   "profilepic"
    t.integer  "author"
    t.text     "about"
    t.string   "password_digest"
    t.string   "remember_token"
    t.datetime "created_at"
    t.datetime "updated_at"
    t.string   "encrypted_password",     default: "", null: false
    t.string   "reset_password_token"
    t.datetime "reset_password_sent_at"
    t.datetime "remember_created_at"
    t.integer  "sign_in_count",          default: 0
    t.datetime "current_sign_in_at"
    t.datetime "last_sign_in_at"
    t.string   "current_sign_in_ip"
    t.string   "last_sign_in_ip"
    t.string   "permalink"
    t.string   "address"
    t.float    "latitude"
    t.float    "longitude"
    t.string   "slug"
    t.text     "youtube1"
    t.text     "youtube2"
    t.text     "youtube3"
    t.string   "videodesc1"
    t.string   "videodesc2"
    t.string   "videodesc3"
  end

  add_index "users", ["email"], name: "index_users_on_email", unique: true, using: :btree
  add_index "users", ["permalink"], name: "index_users_on_permalink", unique: true, using: :btree
  add_index "users", ["remember_token"], name: "index_users_on_remember_token", using: :btree
  add_index "users", ["reset_password_token"], name: "index_users_on_reset_password_token", unique: true, using: :btree
  add_index "users", ["slug"], name: "index_users_on_slug", unique: true, using: :btree

end
