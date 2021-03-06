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

ActiveRecord::Schema.define(version: 20150620092849) do

  # These are extensions that must be enabled in order to support this database
  enable_extension "plpgsql"

  create_table "sprints", force: :cascade do |t|
    t.integer  "starter_id"
    t.text     "obs"
    t.datetime "started_at"
    t.datetime "ended_at"
    t.datetime "deleted_at"
    t.datetime "created_at"
    t.datetime "updated_at"
    t.boolean  "active",     default: false
  end

  add_index "sprints", ["deleted_at"], name: "index_sprints_on_deleted_at", using: :btree

  create_table "sprints_users", force: :cascade do |t|
    t.integer  "sprint_id"
    t.integer  "user_id"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  create_table "stories", force: :cascade do |t|
    t.integer  "pivotal_id"
    t.integer  "sprint_id"
    t.integer  "user_id"
    t.text     "description"
    t.datetime "deleted_at"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  add_index "stories", ["deleted_at"], name: "index_stories_on_deleted_at", using: :btree

  create_table "story_interactions", force: :cascade do |t|
    t.integer  "story_id"
    t.text     "obs"
    t.string   "hashtags",              default: [], array: true
    t.integer  "completion_percentage"
    t.datetime "interacted_at"
    t.datetime "deleted_at"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  add_index "story_interactions", ["deleted_at"], name: "index_story_interactions_on_deleted_at", using: :btree

  create_table "users", force: :cascade do |t|
    t.string   "avatar_url"
    t.string   "email"
    t.string   "name"
    t.string   "slack_uid"
    t.string   "slack_handler"
    t.boolean  "registration_complete"
    t.datetime "created_at"
    t.datetime "updated_at"
    t.string   "avatar_32_url"
    t.string   "avatar_72_url"
  end

end
