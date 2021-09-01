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

ActiveRecord::Schema.define(version: 2021_09_01_190501) do

  # These are extensions that must be enabled in order to support this database
  enable_extension "plpgsql"

  create_table "messages", force: :cascade do |t|
    t.string "text"
    t.string "target_type"
    t.string "action"
    t.string "target"
    t.datetime "created_at", precision: 6, null: false
    t.datetime "updated_at", precision: 6, null: false
    t.bigint "provider_credential_id"
    t.string "target_identifier"
    t.bigint "notification_request_id"
    t.index ["notification_request_id"], name: "index_messages_on_notification_request_id"
    t.index ["provider_credential_id"], name: "index_messages_on_provider_credential_id"
  end

  create_table "notification_requests", force: :cascade do |t|
    t.boolean "fulfilled"
    t.boolean "uniq"
    t.string "target"
    t.string "target_type"
    t.string "content"
    t.string "action"
    t.string "target_identifier"
    t.bigint "provider_credential_id", null: false
    t.datetime "created_at", precision: 6, null: false
    t.datetime "updated_at", precision: 6, null: false
    t.string "json"
    t.index ["provider_credential_id"], name: "index_notification_requests_on_provider_credential_id"
  end

  create_table "provider_credentials", force: :cascade do |t|
    t.string "access_key"
    t.string "team_id"
    t.datetime "created_at", precision: 6, null: false
    t.datetime "updated_at", precision: 6, null: false
    t.string "application_key"
    t.string "team_name"
  end

  add_foreign_key "messages", "notification_requests"
  add_foreign_key "messages", "provider_credentials"
  add_foreign_key "notification_requests", "provider_credentials"
end
