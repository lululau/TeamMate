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

ActiveRecord::Schema.define(version: 20131203145638) do

  create_table "contributors_wikis", id: false, force: true do |t|
    t.integer "user_id", null: false
    t.integer "wiki_id", null: false
  end

  create_table "managers_projects", id: false, force: true do |t|
    t.integer "user_id",    null: false
    t.integer "project_id", null: false
  end

  create_table "members_projects", id: false, force: true do |t|
    t.integer "user_id",    null: false
    t.integer "project_id", null: false
  end

  create_table "projects", force: true do |t|
    t.string   "name"
    t.text     "description"
    t.boolean  "public"
    t.integer  "root_wiki_id"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  create_table "task_journals", force: true do |t|
    t.integer  "time_entry_hours"
    t.integer  "old_done_ratio"
    t.integer  "new_done_ratio"
    t.integer  "task_id"
    t.integer  "operator_id"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  add_index "task_journals", ["operator_id"], name: "index_task_journals_on_operator_id"
  add_index "task_journals", ["task_id"], name: "index_task_journals_on_task_id"

  create_table "tasks", force: true do |t|
    t.string   "category"
    t.string   "subject"
    t.text     "description"
    t.string   "priority"
    t.integer  "assigned_to_user_id"
    t.integer  "parent_id"
    t.date     "start_date"
    t.date     "due_date"
    t.boolean  "at_risk"
    t.string   "reason_of_risk"
    t.integer  "project_id"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  add_index "tasks", ["assigned_to_user_id"], name: "index_tasks_on_assigned_to_user_id"
  add_index "tasks", ["parent_id"], name: "index_tasks_on_parent_id"
  add_index "tasks", ["project_id"], name: "index_tasks_on_project_id"

  create_table "tasks_watchers", id: false, force: true do |t|
    t.integer "user_id", null: false
    t.integer "task_id", null: false
  end

  create_table "users", force: true do |t|
    t.string   "name"
    t.string   "email"
    t.string   "password"
    t.string   "role"
    t.string   "remember_me_token"
    t.integer  "avatar"
    t.boolean  "locked"
    t.datetime "last_signin_time"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  create_table "wikis", force: true do |t|
    t.string   "subject"
    t.text     "content"
    t.integer  "parent_id"
    t.integer  "project_id"
    t.integer  "author_id"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  add_index "wikis", ["author_id"], name: "index_wikis_on_author_id"
  add_index "wikis", ["parent_id"], name: "index_wikis_on_parent_id"
  add_index "wikis", ["project_id"], name: "index_wikis_on_project_id"

end
