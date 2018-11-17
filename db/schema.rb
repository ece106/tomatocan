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

ActiveRecord::Schema.define(version: 20130201000000000) do

  # These are extensions that must be enabled in order to support this database
  enable_extension "plpgsql"

  create_table "agreements", id: :serial, force: :cascade do |t|
    t.integer "user_id"
    t.integer "group_id"
    t.datetime "created_at"
    t.datetime "updated_at"
    t.datetime "approved"
  end

  create_table "books", id: :serial, force: :cascade do |t|
    t.string "title", limit: 255
    t.text "blurb"
    t.date "releasedate"
    t.integer "author_id"
    t.string "genre", limit: 255
    t.string "fiftychar", limit: 255
    t.float "price"
    t.string "bookpdf", limit: 255
    t.string "coverpic", limit: 255
    t.string "coverpicurl", limit: 255
    t.datetime "created_at"
    t.datetime "updated_at"
    t.integer "user_id"
    t.string "bookmobi", limit: 255
    t.string "bookepub", limit: 255
    t.string "bookkobo", limit: 255
    t.string "bookaudio", limit: 255
    t.text "youtube1"
    t.text "youtube2"
    t.string "bkvideodesc1", limit: 255
    t.string "bkvideodesc2", limit: 255
  end

  create_table "events", id: :serial, force: :cascade do |t|
    t.string "name", limit: 255
    t.datetime "start_at"
    t.datetime "end_at"
    t.datetime "created_at"
    t.datetime "updated_at"
    t.text "desc"
    t.string "address", limit: 255
    t.integer "user_id"
    t.float "latitude"
    t.float "longitude"
    t.integer "group1id"
    t.integer "group2id"
    t.integer "group3id"
    t.integer "usrid"
  end

  create_table "friendly_id_slugs", id: :serial, force: :cascade do |t|
    t.string "slug", limit: 255, null: false
    t.integer "sluggable_id", null: false
    t.string "sluggable_type", limit: 50
    t.string "scope", limit: 255
    t.datetime "created_at"
    t.index ["slug", "sluggable_type", "scope"], name: "index_friendly_id_slugs_on_slug_and_sluggable_type_and_scope", unique: true
    t.index ["slug", "sluggable_type"], name: "index_friendly_id_slugs_on_slug_and_sluggable_type"
    t.index ["sluggable_id"], name: "index_friendly_id_slugs_on_sluggable_id"
    t.index ["sluggable_type"], name: "index_friendly_id_slugs_on_sluggable_type"
  end

  create_table "groups", id: :serial, force: :cascade do |t|
    t.string "name", limit: 255
    t.string "address", limit: 255
    t.float "latitude"
    t.float "longitude"
    t.integer "user_id"
    t.text "about"
    t.string "grouppic", limit: 255
    t.datetime "created_at"
    t.datetime "updated_at"
    t.string "grouptype", limit: 255
    t.string "permalink", limit: 255
    t.string "slug", limit: 255
    t.string "newsurl", limit: 255
    t.string "twitter", limit: 255
    t.string "facebook", limit: 255
    t.text "callaction"
    t.string "stripeid", limit: 255
    t.string "stripe_customer_token", limit: 255
    t.datetime "stripesignup"
    t.index ["slug"], name: "index_groups_on_slug", unique: true
  end

  create_table "merchandises", id: :serial, force: :cascade do |t|
    t.string "name", limit: 255
    t.integer "user_id"
    t.float "price"
    t.text "desc"
    t.string "itempic", limit: 255
    t.datetime "created_at"
    t.datetime "updated_at"
    t.datetime "deadline"
    t.float "goal"
    t.string "youtube", limit: 255
    t.string "audio"
    t.string "video"
    t.string "graphic"
    t.string "merchepub"
    t.string "merchmobi"
    t.string "merchpdf"
    t.datetime "expiration"
    t.integer "itempic_crop_x"
    t.integer "itempic_crop_y"
    t.integer "itempic_crop_w"
    t.integer "itempic_crop_h"
    t.string "buttontype"
  end

  create_table "movieroles", force: :cascade do |t|
    t.string "role"
    t.string "roledesc"
    t.integer "user_id"
    t.integer "movie_id"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
  end

  create_table "movies", force: :cascade do |t|
    t.string "title"
    t.text "about"
    t.string "youtube1"
    t.string "youtube2"
    t.string "youtube3"
    t.string "videodesc1"
    t.string "videodesc2"
    t.string "videodesc3"
    t.string "moviepic"
    t.string "genre"
    t.float "price"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.integer "user_id"
    t.string "director"
    t.date "releasedate"
  end

  create_table "phases", id: :serial, force: :cascade do |t|
    t.string "name", limit: 255
    t.integer "user_id"
    t.text "mission"
    t.string "phasepic", limit: 255
    t.datetime "created_at"
    t.datetime "updated_at"
    t.string "permalink", limit: 255
    t.string "slug", limit: 255
    t.datetime "deadline"
    t.string "why_classy"
    t.string "youtube"
    t.index ["slug"], name: "index_phases_on_slug", unique: true
  end

  create_table "purchases", id: :serial, force: :cascade do |t|
    t.integer "author_id"
    t.integer "book_id"
    t.string "stripe_customer_token", limit: 255
    t.integer "plan_id"
    t.datetime "created_at"
    t.datetime "updated_at"
    t.string "stripe_card_token", limit: 255
    t.integer "user_id"
    t.string "bookfiletype", limit: 255
    t.float "pricesold"
    t.decimal "authorcut", precision: 8, scale: 2
    t.date "paid"
    t.integer "merchandise_id"
    t.integer "group_id"
    t.decimal "groupcut", precision: 8, scale: 2
    t.string "shipaddress", limit: 255
    t.string "fulfillstatus", limit: 255
    t.string "email"
  end

  create_table "relationships", force: :cascade do |t|
    t.integer "follower_id"
    t.integer "followed_id"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["followed_id"], name: "index_relationships_on_followed_id"
    t.index ["follower_id", "followed_id"], name: "index_relationships_on_follower_id_and_followed_id", unique: true
    t.index ["follower_id"], name: "index_relationships_on_follower_id"
  end

  create_table "reviews", id: :serial, force: :cascade do |t|
    t.text "blurb"
    t.integer "user_id"
    t.integer "book_id"
    t.integer "star"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  create_table "rsvpqs", id: :serial, force: :cascade do |t|
    t.integer "event_id"
    t.integer "user_id"
    t.integer "guests"
    t.datetime "created_at"
    t.datetime "updated_at"
    t.string "email"
  end

  create_table "users", id: :serial, force: :cascade do |t|
    t.string "name", limit: 255
    t.string "email", limit: 255
    t.text "ustreamvid"
    t.text "ustreamsocial"
    t.string "twitter", limit: 255
    t.string "facebook", limit: 255
    t.string "pinterest", limit: 255
    t.string "youtube", limit: 255
    t.string "genre1", limit: 255
    t.string "genre2", limit: 255
    t.string "genre3", limit: 255
    t.string "blogurl", limit: 255
    t.string "profilepicurl", limit: 255
    t.string "profilepic", limit: 255
    t.string "author", limit: 255
    t.text "about"
    t.string "password_digest", limit: 255
    t.string "remember_token", limit: 255
    t.datetime "created_at"
    t.datetime "updated_at"
    t.string "encrypted_password", limit: 255, default: "", null: false
    t.string "reset_password_token", limit: 255
    t.datetime "reset_password_sent_at"
    t.datetime "remember_created_at"
    t.integer "sign_in_count", default: 0
    t.datetime "current_sign_in_at"
    t.datetime "last_sign_in_at"
    t.string "current_sign_in_ip", limit: 255
    t.string "last_sign_in_ip", limit: 255
    t.string "permalink", limit: 255
    t.string "address", limit: 255
    t.float "latitude"
    t.float "longitude"
    t.string "slug", limit: 255
    t.text "youtube1"
    t.text "youtube2"
    t.text "youtube3"
    t.string "videodesc1", limit: 255
    t.string "videodesc2", limit: 255
    t.string "videodesc3", limit: 255
    t.string "blogradio", limit: 255
    t.text "blogtalkradio"
    t.string "stripeid", limit: 255
    t.string "stripe_customer_token", limit: 255
    t.datetime "stripesignup"
    t.string "bannerpic"
    t.index ["email"], name: "index_users_on_email", unique: true
    t.index ["permalink"], name: "index_users_on_permalink", unique: true
    t.index ["remember_token"], name: "index_users_on_remember_token"
    t.index ["reset_password_token"], name: "index_users_on_reset_password_token", unique: true
    t.index ["slug"], name: "index_users_on_slug", unique: true
  end

end
