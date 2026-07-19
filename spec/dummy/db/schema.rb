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

ActiveRecord::Schema[8.1].define(version: 2026_07_12_110028) do
  create_table "rails_iam_permissions", force: :cascade do |t|
    t.string "code"
    t.datetime "created_at", null: false
    t.string "created_by"
    t.datetime "deleted_at"
    t.string "deleted_by"
    t.text "description"
    t.datetime "updated_at", null: false
    t.string "updated_by"
    t.index ["code"], name: "index_rails_iam_permissions_on_code", unique: true
  end

  create_table "rails_iam_refresh_tokens", force: :cascade do |t|
    t.datetime "created_at", null: false
    t.datetime "expires_at", null: false
    t.string "ip_address"
    t.string "jti"
    t.datetime "last_used_at"
    t.datetime "revoked_at"
    t.string "token_digest"
    t.datetime "updated_at", null: false
    t.string "user_agent"
    t.integer "user_id", null: false
    t.index ["jti"], name: "index_rails_iam_refresh_tokens_on_jti", unique: true
    t.index ["token_digest"], name: "index_rails_iam_refresh_tokens_on_token_digest", unique: true
    t.index ["user_id"], name: "index_rails_iam_refresh_tokens_on_user_id"
  end

  create_table "rails_iam_role_permissions", force: :cascade do |t|
    t.datetime "created_at", null: false
    t.string "created_by"
    t.datetime "deleted_at"
    t.string "deleted_by"
    t.integer "permission_id", null: false
    t.integer "role_id", null: false
    t.datetime "updated_at", null: false
    t.string "updated_by"
    t.index ["permission_id"], name: "index_rails_iam_role_permissions_on_permission_id"
    t.index ["role_id"], name: "index_rails_iam_role_permissions_on_role_id"
  end

  create_table "rails_iam_roles", force: :cascade do |t|
    t.datetime "created_at", null: false
    t.string "created_by"
    t.datetime "deleted_at"
    t.string "deleted_by"
    t.text "description"
    t.string "name"
    t.datetime "updated_at", null: false
    t.string "updated_by"
    t.index ["name"], name: "index_rails_iam_roles_on_name", unique: true
  end

  create_table "rails_iam_user_denied_permissions", force: :cascade do |t|
    t.datetime "created_at", null: false
    t.string "created_by"
    t.datetime "deleted_at"
    t.string "deleted_by"
    t.integer "permission_id", null: false
    t.datetime "updated_at", null: false
    t.string "updated_by"
    t.integer "user_id", null: false
    t.index ["permission_id"], name: "index_rails_iam_user_denied_permissions_on_permission_id"
    t.index ["user_id"], name: "index_rails_iam_user_denied_permissions_on_user_id"
  end

  create_table "rails_iam_user_permissions", force: :cascade do |t|
    t.datetime "created_at", null: false
    t.string "created_by"
    t.datetime "deleted_at"
    t.string "deleted_by"
    t.integer "permission_id", null: false
    t.datetime "updated_at", null: false
    t.string "updated_by"
    t.integer "user_id", null: false
    t.index ["permission_id"], name: "index_rails_iam_user_permissions_on_permission_id"
    t.index ["user_id"], name: "index_rails_iam_user_permissions_on_user_id"
  end

  create_table "rails_iam_user_roles", force: :cascade do |t|
    t.datetime "created_at", null: false
    t.string "created_by"
    t.datetime "deleted_at"
    t.string "deleted_by"
    t.integer "role_id", null: false
    t.datetime "updated_at", null: false
    t.string "updated_by"
    t.integer "user_id", null: false
    t.index ["role_id"], name: "index_rails_iam_user_roles_on_role_id"
    t.index ["user_id"], name: "index_rails_iam_user_roles_on_user_id"
  end

  create_table "rails_iam_users", force: :cascade do |t|
    t.datetime "created_at", null: false
    t.string "created_by"
    t.datetime "deleted_at"
    t.string "deleted_by"
    t.string "email"
    t.string "password_digest"
    t.datetime "updated_at", null: false
    t.string "updated_by"
    t.index ["email"], name: "index_rails_iam_users_on_email", unique: true
  end

  add_foreign_key "rails_iam_refresh_tokens", "rails_iam_users", column: "user_id"
  add_foreign_key "rails_iam_role_permissions", "rails_iam_permissions", column: "permission_id"
  add_foreign_key "rails_iam_role_permissions", "rails_iam_roles", column: "role_id"
  add_foreign_key "rails_iam_user_denied_permissions", "rails_iam_permissions", column: "permission_id"
  add_foreign_key "rails_iam_user_denied_permissions", "rails_iam_users", column: "user_id"
  add_foreign_key "rails_iam_user_permissions", "rails_iam_permissions", column: "permission_id"
  add_foreign_key "rails_iam_user_permissions", "rails_iam_users", column: "user_id"
  add_foreign_key "rails_iam_user_roles", "rails_iam_roles", column: "role_id"
  add_foreign_key "rails_iam_user_roles", "rails_iam_users", column: "user_id"
end
