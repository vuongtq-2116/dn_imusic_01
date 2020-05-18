# This file is auto-generated from the current state of the database. Instead
# of editing this file, please use the migrations feature of Active Record to
# incrementally modify your database, and then regenerate this schema definition.
#
# This file is the source Rails uses to define your schema when running `rails
# db:schema:load`. When creating a new database, `rails db:schema:load` tends to
# be faster and is potentially less error prone than running all of your
# migrations from scratch. Old migrations may fail to apply correctly if those
# migrations use external dependencies or application code.
#
# It's strongly recommended that you check this file into your version control system.

ActiveRecord::Schema.define(version: 2020_05_19_043429) do

  # These are extensions that must be enabled in order to support this database
  enable_extension "plpgsql"

  create_table "album_songs", force: :cascade do |t|
    t.bigint "song_id", null: false
    t.bigint "album_id", null: false
    t.datetime "created_at", precision: 6, null: false
    t.datetime "updated_at", precision: 6, null: false
    t.index ["album_id"], name: "index_album_songs_on_album_id"
    t.index ["song_id"], name: "index_album_songs_on_song_id"
  end

  create_table "albums", force: :cascade do |t|
    t.string "name", null: false
    t.datetime "created_at", precision: 6, null: false
    t.datetime "updated_at", precision: 6, null: false
  end

  create_table "categories", force: :cascade do |t|
    t.string "name", null: false
    t.datetime "created_at", precision: 6, null: false
    t.datetime "updated_at", precision: 6, null: false
  end

  create_table "comments", force: :cascade do |t|
    t.text "content"
    t.bigint "song_id", null: false
    t.bigint "user_id", null: false
    t.datetime "created_at", precision: 6, null: false
    t.datetime "updated_at", precision: 6, null: false
    t.index ["song_id"], name: "index_comments_on_song_id"
    t.index ["user_id"], name: "index_comments_on_user_id"
  end

  create_table "favorite_songs", force: :cascade do |t|
    t.bigint "song_id", null: false
    t.bigint "user_id", null: false
    t.datetime "created_at", precision: 6, null: false
    t.datetime "updated_at", precision: 6, null: false
    t.index ["song_id"], name: "index_favorite_songs_on_song_id"
    t.index ["user_id"], name: "index_favorite_songs_on_user_id"
  end

  create_table "lyric_requests", force: :cascade do |t|
    t.text "lyric_detail"
    t.integer "status"
    t.bigint "song_id", null: false
    t.bigint "user_id", null: false
    t.datetime "created_at", precision: 6, null: false
    t.datetime "updated_at", precision: 6, null: false
    t.index ["song_id"], name: "index_lyric_requests_on_song_id"
    t.index ["user_id"], name: "index_lyric_requests_on_user_id"
  end

  create_table "ratings", force: :cascade do |t|
    t.float "star"
    t.bigint "song_id", null: false
    t.bigint "user_id", null: false
    t.datetime "created_at", precision: 6, null: false
    t.datetime "updated_at", precision: 6, null: false
    t.index ["song_id"], name: "index_ratings_on_song_id"
    t.index ["user_id"], name: "index_ratings_on_user_id"
  end

  create_table "songs", force: :cascade do |t|
    t.string "name", null: false
    t.string "link"
    t.text "description"
    t.string "artist"
    t.float "star_avg", default: 0.0
    t.bigint "user_id", null: false
    t.bigint "category_id", null: false
    t.datetime "created_at", precision: 6, null: false
    t.datetime "updated_at", precision: 6, null: false
    t.index ["category_id"], name: "index_songs_on_category_id"
    t.index ["user_id"], name: "index_songs_on_user_id"
  end

  create_table "users", force: :cascade do |t|
    t.string "name"
    t.string "email"
    t.string "password_digest"
    t.integer "role", default: 0
    t.datetime "created_at", precision: 6, null: false
    t.datetime "updated_at", precision: 6, null: false
    t.index ["email"], name: "index_users_on_email", unique: true
  end

  add_foreign_key "album_songs", "albums"
  add_foreign_key "album_songs", "songs"
  add_foreign_key "comments", "songs"
  add_foreign_key "comments", "users"
  add_foreign_key "favorite_songs", "songs"
  add_foreign_key "favorite_songs", "users"
  add_foreign_key "lyric_requests", "songs"
  add_foreign_key "lyric_requests", "users"
  add_foreign_key "ratings", "songs"
  add_foreign_key "ratings", "users"
  add_foreign_key "songs", "categories"
  add_foreign_key "songs", "users"
end
