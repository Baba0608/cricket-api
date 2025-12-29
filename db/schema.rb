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

ActiveRecord::Schema[8.0].define(version: 2025_12_26_111509) do
  # These are extensions that must be enabled in order to support this database
  enable_extension "pg_catalog.plpgsql"

  create_table "friendships", force: :cascade do |t|
    t.bigint "player_id", null: false
    t.bigint "friend_id", null: false
    t.string "status"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["friend_id"], name: "index_friendships_on_friend_id"
    t.index ["player_id", "friend_id"], name: "index_friendships_on_player_id_and_friend_id", unique: true
    t.index ["player_id"], name: "index_friendships_on_player_id"
  end

  create_table "match_invites", force: :cascade do |t|
    t.integer "invite_by_team_id"
    t.integer "receive_by_team_id"
    t.string "status"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
  end

  create_table "match_player_invites", force: :cascade do |t|
    t.bigint "match_id", null: false
    t.bigint "team_id", null: false
    t.bigint "player_id", null: false
    t.integer "status"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["match_id"], name: "index_match_player_invites_on_match_id"
    t.index ["player_id"], name: "index_match_player_invites_on_player_id"
    t.index ["team_id"], name: "index_match_player_invites_on_team_id"
  end

  create_table "matches", force: :cascade do |t|
    t.integer "team_a_id", null: false
    t.integer "team_b_id", null: false
    t.integer "toss_won_by_team_id"
    t.string "toss_won_by_team_choose_to"
    t.integer "winner_team_id"
    t.integer "won_by_runs"
    t.integer "won_by_wickets"
    t.integer "status", default: 0
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
  end

  create_table "players", force: :cascade do |t|
    t.string "name"
    t.string "role"
    t.string "bat_hand"
    t.string "bowl_hand"
    t.string "unique_id"
    t.bigint "user_id", null: false
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["user_id"], name: "index_players_on_user_id"
  end

  create_table "teams", force: :cascade do |t|
    t.string "name"
    t.bigint "created_by_player_id", null: false
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["created_by_player_id"], name: "index_teams_on_created_by_player_id"
  end

  create_table "users", force: :cascade do |t|
    t.string "email"
    t.string "name"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.string "password_digest"
  end

  add_foreign_key "friendships", "players"
  add_foreign_key "friendships", "players", column: "friend_id"
  add_foreign_key "match_invites", "teams", column: "invite_by_team_id"
  add_foreign_key "match_invites", "teams", column: "receive_by_team_id"
  add_foreign_key "match_player_invites", "matches"
  add_foreign_key "match_player_invites", "players"
  add_foreign_key "match_player_invites", "teams"
  add_foreign_key "matches", "teams", column: "team_a_id"
  add_foreign_key "matches", "teams", column: "team_b_id"
  add_foreign_key "matches", "teams", column: "toss_won_by_team_id"
  add_foreign_key "matches", "teams", column: "winner_team_id"
  add_foreign_key "players", "users"
  add_foreign_key "teams", "players", column: "created_by_player_id"
  add_foreign_key "teams", "players", column: "created_by_player_id"
end
