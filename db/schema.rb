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

ActiveRecord::Schema.define(version: 20140108151243) do

  create_table "channels", force: true do |t|
    t.string   "name"
    t.string   "queue_path"
    t.string   "success_path"
    t.string   "error_path"
    t.string   "ftp_path"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  create_table "channels_admins", force: true do |t|
    t.integer  "channel_id"
    t.integer  "user_id"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  add_index "channels_admins", ["channel_id"], name: "index_channels_admins_on_channel_id"
  add_index "channels_admins", ["user_id"], name: "index_channels_admins_on_user_id"

  create_table "channels_contacts", force: true do |t|
    t.integer  "channel_id"
    t.integer  "user_id"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  add_index "channels_contacts", ["channel_id"], name: "index_channels_contacts_on_channel_id"
  add_index "channels_contacts", ["user_id"], name: "index_channels_contacts_on_user_id"

  create_table "channels_users", force: true do |t|
    t.integer  "channel_id"
    t.integer  "user_id"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  add_index "channels_users", ["channel_id"], name: "index_channels_users_on_channel_id"
  add_index "channels_users", ["user_id"], name: "index_channels_users_on_user_id"

  create_table "ftps", force: true do |t|
    t.string   "host"
    t.integer  "post"
    t.string   "user",               default: "", null: false
    t.string   "encrypted_password", default: "", null: false
    t.string   "root_path"
    t.integer  "channel_id"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  create_table "users", force: true do |t|
    t.string   "email",                  default: "", null: false
    t.string   "encrypted_password",     default: "", null: false
    t.string   "role"
    t.string   "reset_password_token"
    t.datetime "reset_password_sent_at"
    t.datetime "remember_created_at"
    t.integer  "sign_in_count",          default: 0
    t.datetime "current_sign_in_at"
    t.datetime "last_sign_in_at"
    t.string   "current_sign_in_ip"
    t.string   "last_sign_in_ip"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  add_index "users", ["email"], name: "index_users_on_email", unique: true
  add_index "users", ["reset_password_token"], name: "index_users_on_reset_password_token", unique: true

end
