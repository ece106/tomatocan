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
# It's strongly recommended to check this file into your version control system.

ActiveRecord::Schema.define(:version => 20130911002912) do

  create_table "books", :force => true do |t|
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
  end

  create_table "reviews", :force => true do |t|
    t.text     "blurb"
    t.integer  "user_id"
    t.integer  "book_id"
    t.integer  "star"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  create_table "users", :force => true do |t|
    t.string   "name"
    t.string   "email"
    t.text     "ustreamvid"
    t.string   "ustreamsocial"
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
    t.string   "encrypted_password",     :default => "", :null => false
    t.string   "reset_password_token"
    t.datetime "reset_password_sent_at"
    t.datetime "remember_created_at"
    t.integer  "sign_in_count",          :default => 0
    t.datetime "current_sign_in_at"
    t.datetime "last_sign_in_at"
    t.string   "current_sign_in_ip"
    t.string   "last_sign_in_ip"
    t.string   "bookmobi"
    t.string   "bookepub"
    t.string   "bookkobo"
  end

  add_index "users", ["email"], :name => "index_users_on_email", :unique => true
  add_index "users", ["remember_token"], :name => "index_users_on_remember_token"
  add_index "users", ["reset_password_token"], :name => "index_users_on_reset_password_token", :unique => true

end
