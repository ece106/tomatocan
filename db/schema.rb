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

# Could not dump table "agreements" because of following StandardError
#   Unknown type 'serial' for column 'id'

# Could not dump table "books" because of following StandardError
#   Unknown type 'serial' for column 'id'

# Could not dump table "events" because of following StandardError
#   Unknown type 'serial' for column 'id'

# Could not dump table "friendly_id_slugs" because of following StandardError
#   Unknown type 'serial' for column 'id'

# Could not dump table "groups" because of following StandardError
#   Unknown type 'serial' for column 'id'

# Could not dump table "merchandises" because of following StandardError
#   Unknown type 'serial' for column 'id'

  create_table "movieroles", force: :cascade do |t|
    t.string "role"
    t.string "roledesc"
    t.integer "user_id"
    t.integer "movie_id"
    t.datetime "created_at"
    t.datetime "updated_at"
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
    t.datetime "created_at"
    t.datetime "updated_at"
    t.integer "user_id"
    t.string "director"
    t.date "releasedate"
  end

# Could not dump table "phases" because of following StandardError
#   Unknown type 'serial' for column 'id'

# Could not dump table "purchases" because of following StandardError
#   Unknown type 'serial' for column 'id'

  create_table "relationships", force: :cascade do |t|
    t.integer "follower_id"
    t.integer "followed_id"
    t.datetime "created_at"
    t.datetime "updated_at"
    t.index ["followed_id"], name: "index_relationships_on_followed_id"
    t.index ["follower_id", "followed_id"], name: "index_relationships_on_follower_id_and_followed_id", unique: true
    t.index ["follower_id"], name: "index_relationships_on_follower_id"
  end

# Could not dump table "reviews" because of following StandardError
#   Unknown type 'serial' for column 'id'

# Could not dump table "rsvpqs" because of following StandardError
#   Unknown type 'serial' for column 'id'

# Could not dump table "users" because of following StandardError
#   Unknown type 'serial' for column 'id'

end
