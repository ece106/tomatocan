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

ActiveRecord::Schema.define(:version => 20130329015056) do

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
  end

  add_index "users", ["remember_token"], :name => "index_users_on_remember_token"

end
