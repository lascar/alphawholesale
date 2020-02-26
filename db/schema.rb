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

ActiveRecord::Schema.define(version: 2020_02_03_144825) do

  # These are extensions that must be enabled in order to support this database
  enable_extension "hstore"
  enable_extension "plpgsql"

  create_table "attached_products", force: :cascade do |t|
    t.string "product"
    t.jsonb "definition", default: {}, null: false
    t.string "attachable_type", null: false
    t.bigint "attachable_id", null: false
    t.boolean "mailing", default: false
    t.datetime "created_at", precision: 6, null: false
    t.datetime "updated_at", precision: 6, null: false
    t.index ["attachable_type", "attachable_id"], name: "index_attached_products_on_attachable_type_and_attachable_id"
    t.index ["definition"], name: "index_attached_products_on_definition", using: :gin
  end

  create_table "brokers", force: :cascade do |t|
    t.string "email"
    t.string "identifier", default: "", null: false
    t.string "encrypted_password", default: "", null: false
    t.string "reset_password_token"
    t.datetime "reset_password_sent_at"
    t.datetime "remember_created_at"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["identifier"], name: "index_brokers_on_identifier", unique: true
    t.index ["reset_password_token"], name: "index_brokers_on_reset_password_token", unique: true
  end

  create_table "customers", force: :cascade do |t|
    t.string "entreprise_name"
    t.string "email"
    t.string "tin"
    t.string "street_and_number"
    t.string "city"
    t.string "postal_code"
    t.string "state"
    t.string "country"
    t.string "telephone_number1"
    t.string "telephone_number2"
    t.string "identifier", default: "", null: false
    t.string "currency"
    t.string "unit_type"
    t.string "encrypted_password", default: "", null: false
    t.string "reset_password_token"
    t.datetime "reset_password_sent_at"
    t.datetime "remember_created_at"
    t.boolean "approved", default: false
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["approved"], name: "index_customers_on_approved"
    t.index ["identifier"], name: "index_customers_on_identifier", unique: true
    t.index ["reset_password_token"], name: "index_customers_on_reset_password_token", unique: true
  end

  create_table "offers", force: :cascade do |t|
    t.bigint "supplier_id"
    t.bigint "attached_product_id"
    t.integer "quantity"
    t.decimal "unit_price_supplier", precision: 8, scale: 2, default: "0.0", null: false
    t.decimal "unit_price_broker", precision: 8, scale: 2, default: "0.0", null: false
    t.string "localisation_supplier"
    t.string "localisation_broker"
    t.string "incoterm"
    t.text "supplier_observation"
    t.date "date_start"
    t.date "date_end"
    t.boolean "approved", default: false
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["attached_product_id"], name: "index_offers_on_attached_product_id"
    t.index ["supplier_id"], name: "index_offers_on_supplier_id"
  end

  create_table "orders", force: :cascade do |t|
    t.bigint "customer_id"
    t.bigint "offer_id"
    t.text "customer_observation"
    t.integer "quantity", default: 1
    t.boolean "approved", default: false
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["customer_id"], name: "index_orders_on_customer_id"
    t.index ["offer_id"], name: "index_orders_on_offer_id"
  end

  create_table "products", force: :cascade do |t|
    t.string "name"
    t.jsonb "assortments", default: {}, null: false
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
  end

  create_table "suppliers", force: :cascade do |t|
    t.string "entreprise_name"
    t.string "email"
    t.string "tin"
    t.string "street_and_number"
    t.string "city"
    t.string "postal_code"
    t.string "state"
    t.string "country"
    t.string "telephone_number1"
    t.string "telephone_number2"
    t.string "identifier", default: "", null: false
    t.string "currency"
    t.string "unit_type"
    t.string "encrypted_password", default: "", null: false
    t.string "reset_password_token"
    t.datetime "reset_password_sent_at"
    t.datetime "remember_created_at"
    t.boolean "approved", default: false
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["approved"], name: "index_suppliers_on_approved"
    t.index ["identifier"], name: "index_suppliers_on_identifier", unique: true
    t.index ["reset_password_token"], name: "index_suppliers_on_reset_password_token", unique: true
  end

  create_table "user_products", force: :cascade do |t|
    t.string "user_type", null: false
    t.bigint "user_id", null: false
    t.jsonb "products", default: []
    t.datetime "created_at", precision: 6, null: false
    t.datetime "updated_at", precision: 6, null: false
    t.index ["products"], name: "index_user_products_on_products", using: :gin
    t.index ["user_type", "user_id"], name: "index_user_products_on_user_type_and_user_id"
  end

end
