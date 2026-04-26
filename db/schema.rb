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

ActiveRecord::Schema[7.1].define(version: 2026_04_20_080036) do
  create_table "leases", force: :cascade do |t|
    t.integer "tenant_id", null: false
    t.integer "unit_id", null: false
    t.date "start_date"
    t.date "end_date"
    t.decimal "rent_amount"
    t.date "due_date"
    t.integer "status"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.decimal "late_fee"
    t.integer "balance_due_cents"
    t.index ["tenant_id"], name: "index_leases_on_tenant_id"
    t.index ["unit_id"], name: "index_leases_on_unit_id"
  end

  create_table "payment_allocations", force: :cascade do |t|
    t.integer "payment_id", null: false
    t.integer "lease_id", null: false
    t.integer "amount_cents"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["lease_id"], name: "index_payment_allocations_on_lease_id"
    t.index ["payment_id"], name: "index_payment_allocations_on_payment_id"
  end

  create_table "payments", force: :cascade do |t|
    t.integer "tenant_id", null: false
    t.integer "lease_id", null: false
    t.decimal "amount"
    t.date "payment_date"
    t.integer "status"
    t.string "transaction_id"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["lease_id"], name: "index_payments_on_lease_id"
    t.index ["tenant_id"], name: "index_payments_on_tenant_id"
  end

  create_table "tenants", force: :cascade do |t|
    t.string "name"
    t.string "email"
    t.string "phone"
    t.integer "status"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.integer "user_id"
    t.integer "owner_id"
    t.index ["owner_id"], name: "index_tenants_on_owner_id"
    t.index ["user_id"], name: "index_tenants_on_user_id"
  end

  create_table "units", force: :cascade do |t|
    t.string "name"
    t.decimal "rent_amount"
    t.integer "status"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.integer "owner_id"
    t.index ["owner_id"], name: "index_units_on_owner_id"
  end

  create_table "users", force: :cascade do |t|
    t.string "email", default: "", null: false
    t.string "encrypted_password", default: "", null: false
    t.string "reset_password_token"
    t.datetime "reset_password_sent_at"
    t.datetime "remember_created_at"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.integer "role", default: 1
    t.string "confirmation_token"
    t.datetime "confirmed_at"
    t.datetime "confirmation_sent_at"
    t.string "unconfirmed_email"
    t.string "otp_code"
    t.datetime "otp_sent_at"
    t.datetime "otp_verified_at"
    t.index ["confirmation_token"], name: "index_users_on_confirmation_token", unique: true
    t.index ["email"], name: "index_users_on_email", unique: true
    t.index ["reset_password_token"], name: "index_users_on_reset_password_token", unique: true
  end

  add_foreign_key "leases", "tenants"
  add_foreign_key "leases", "units"
  add_foreign_key "payment_allocations", "leases"
  add_foreign_key "payment_allocations", "payments"
  add_foreign_key "payments", "leases"
  add_foreign_key "payments", "tenants"
  add_foreign_key "tenants", "users"
  add_foreign_key "tenants", "users", column: "owner_id"
  add_foreign_key "units", "users", column: "owner_id"
end
