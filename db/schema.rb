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

ActiveRecord::Schema.define(version: 20140626113949) do

  # These are extensions that must be enabled in order to support this database
  enable_extension "plpgsql"

  create_table "bank_types", force: true do |t|
    t.string   "name"
    t.datetime "created_at"
    t.datetime "updated_at"
    t.boolean  "published"
  end

  create_table "banks", force: true do |t|
    t.string   "name"
    t.integer  "bank_type_id"
    t.datetime "created_at"
    t.datetime "updated_at"
    t.boolean  "published"
  end

  create_table "compensations", force: true do |t|
    t.string   "cuid"
    t.string   "label"
    t.datetime "created_at"
    t.datetime "updated_at"
    t.boolean  "published"
  end

  create_table "inheritor_types", force: true do |t|
    t.string   "label"
    t.datetime "created_at"
    t.datetime "updated_at"
    t.boolean  "published"
  end

  create_table "inheritors", force: true do |t|
    t.string   "name"
    t.string   "phone_number"
    t.string   "email"
    t.string   "address"
    t.string   "account_number"
    t.datetime "created_at"
    t.datetime "updated_at"
    t.integer  "inheritor_type_id"
  end

  create_table "inheritors_operation_types", id: false, force: true do |t|
    t.integer "inheritor_id"
    t.integer "operation_type_id"
    t.float   "percentage"
  end

  create_table "operation_types", force: true do |t|
    t.string   "name"
    t.integer  "service_id"
    t.integer  "credit_status"
    t.datetime "created_at"
    t.datetime "updated_at"
    t.boolean  "published"
    t.string   "comment"
  end

  create_table "parameters", force: true do |t|
    t.string   "back_office_url"
    t.string   "emission_authentication_token"
    t.string   "reception_authentication_token"
    t.datetime "created_at"
    t.datetime "updated_at"
    t.string   "hubs_back_office_url"
  end

  create_table "payment_way_fees", force: true do |t|
    t.string   "code"
    t.string   "name"
    t.float    "fee"
    t.boolean  "percentage"
    t.datetime "created_at"
    t.datetime "updated_at"
    t.boolean  "enabled"
  end

  create_table "payment_ways", force: true do |t|
    t.string   "name"
    t.boolean  "published"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  create_table "profiles", force: true do |t|
    t.string   "name"
    t.datetime "created_at"
    t.datetime "updated_at"
    t.string   "shortcut"
    t.boolean  "published"
    t.boolean  "create_user"
    t.boolean  "edit_user_data"
    t.boolean  "create_service"
    t.boolean  "edit_service"
    t.boolean  "create_operation"
    t.boolean  "edit_operation"
    t.boolean  "create_inheritor"
    t.boolean  "edit_inheritor"
    t.boolean  "create_bank"
    t.boolean  "edit_bank"
    t.boolean  "create_wallet"
    t.boolean  "edit_wallet"
    t.boolean  "view_transactions"
    t.boolean  "create_profile"
    t.boolean  "edit_profile"
  end

  create_table "services", force: true do |t|
    t.string   "code"
    t.string   "name"
    t.string   "sales_area"
    t.string   "url_on_success"
    t.string   "url_on_error"
    t.string   "url_on_session_expired"
    t.string   "url_on_hold_success"
    t.string   "url_on_hold_error"
    t.string   "url_on_hold_listener"
    t.boolean  "published"
    t.string   "url_on_basket_already_paid"
    t.boolean  "notified_to_hubs_front_office"
    t.boolean  "notified_to_hubs_back_office"
    t.datetime "created_at"
    t.datetime "updated_at"
    t.integer  "compensation_id"
    t.string   "url_to_ipn"
  end

  create_table "sessions", force: true do |t|
    t.string   "session_id", null: false
    t.text     "data"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  add_index "sessions", ["session_id"], name: "index_sessions_on_session_id", unique: true, using: :btree
  add_index "sessions", ["updated_at"], name: "index_sessions_on_updated_at", using: :btree

  create_table "users", force: true do |t|
    t.string   "email",                  default: "", null: false
    t.string   "encrypted_password",     default: "", null: false
    t.string   "reset_password_token"
    t.datetime "reset_password_sent_at"
    t.datetime "remember_created_at"
    t.integer  "sign_in_count",          default: 0,  null: false
    t.datetime "current_sign_in_at"
    t.datetime "last_sign_in_at"
    t.string   "current_sign_in_ip"
    t.string   "last_sign_in_ip"
    t.string   "firstname"
    t.string   "lastname"
    t.string   "phone_number"
    t.string   "mobile_number"
    t.string   "confirmation_token"
    t.datetime "confirmed_at"
    t.datetime "confirmation_sent_at"
    t.string   "unconfirmed_email"
    t.datetime "created_at"
    t.datetime "updated_at"
    t.integer  "profile_id"
    t.boolean  "published"
  end

  add_index "users", ["email"], name: "index_users_on_email", unique: true, using: :btree
  add_index "users", ["reset_password_token"], name: "index_users_on_reset_password_token", unique: true, using: :btree

end
