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

ActiveRecord::Schema.define(version: 2019_09_06_142530) do

  # These are extensions that must be enabled in order to support this database
  enable_extension "plpgsql"

  create_table "aspects", force: :cascade do |t|
    t.bigint "supplier_id"
    t.bigint "product_id"
    t.string "name"
    t.boolean "approved", default: false
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["product_id"], name: "index_aspects_on_product_id"
    t.index ["supplier_id"], name: "index_aspects_on_supplier_id"
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
    t.boolean "approved", default: false
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
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["approved"], name: "index_customers_on_approved"
    t.index ["identifier"], name: "index_customers_on_identifier", unique: true
    t.index ["reset_password_token"], name: "index_customers_on_reset_password_token", unique: true
  end

  create_table "offers", force: :cascade do |t|
    t.bigint "supplier_id"
    t.bigint "product_id"
    t.bigint "variety_id"
    t.bigint "aspect_id"
    t.bigint "size_id"
    t.bigint "packaging_id"
    t.boolean "approved", default: false
    t.integer "quantity"
    t.decimal "unit_price_supplier", precision: 8, scale: 2, default: "0.0", null: false
    t.decimal "unit_price_broker", precision: 8, scale: 2, default: "0.0", null: false
    t.string "localisation_supplier"
    t.string "localisation_broker"
    t.string "incoterm"
    t.text "observation"
    t.date "date_start"
    t.date "date_end"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["aspect_id"], name: "index_offers_on_aspect_id"
    t.index ["packaging_id"], name: "index_offers_on_packaging_id"
    t.index ["product_id"], name: "index_offers_on_product_id"
    t.index ["size_id"], name: "index_offers_on_size_id"
    t.index ["supplier_id"], name: "index_offers_on_supplier_id"
    t.index ["variety_id"], name: "index_offers_on_variety_id"
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

  create_table "packagings", force: :cascade do |t|
    t.bigint "supplier_id"
    t.bigint "product_id"
    t.string "name"
    t.boolean "approved", default: false
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["product_id"], name: "index_packagings_on_product_id"
    t.index ["supplier_id"], name: "index_packagings_on_supplier_id"
  end

  create_table "product_customers", force: :cascade do |t|
    t.bigint "customer_id"
    t.bigint "product_id"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["customer_id"], name: "index_product_customers_on_customer_id"
    t.index ["product_id"], name: "index_product_customers_on_product_id"
  end

  create_table "product_suppliers", force: :cascade do |t|
    t.bigint "supplier_id"
    t.bigint "product_id"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["product_id"], name: "index_product_suppliers_on_product_id"
    t.index ["supplier_id"], name: "index_product_suppliers_on_supplier_id"
  end

  create_table "products", force: :cascade do |t|
    t.bigint "supplier_id"
    t.string "reference"
    t.string "name"
    t.string "variety"
    t.boolean "approved", default: false
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["supplier_id"], name: "index_products_on_supplier_id"
  end

  create_table "sizes", force: :cascade do |t|
    t.bigint "supplier_id"
    t.bigint "product_id"
    t.string "name"
    t.boolean "approved", default: false
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["product_id"], name: "index_sizes_on_product_id"
    t.index ["supplier_id"], name: "index_sizes_on_supplier_id"
  end

  create_table "suppliers", force: :cascade do |t|
    t.boolean "approved", default: false
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
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["approved"], name: "index_suppliers_on_approved"
    t.index ["identifier"], name: "index_suppliers_on_identifier", unique: true
    t.index ["reset_password_token"], name: "index_suppliers_on_reset_password_token", unique: true
  end

  create_table "tender_lines", force: :cascade do |t|
    t.bigint "tender_id"
    t.bigint "product_id"
    t.bigint "variety_id"
    t.bigint "aspect_id"
    t.bigint "size_id"
    t.bigint "packaging_id"
    t.integer "unit"
    t.integer "unit_price"
    t.text "observation"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["aspect_id"], name: "index_tender_lines_on_aspect_id"
    t.index ["packaging_id"], name: "index_tender_lines_on_packaging_id"
    t.index ["product_id"], name: "index_tender_lines_on_product_id"
    t.index ["size_id"], name: "index_tender_lines_on_size_id"
    t.index ["tender_id"], name: "index_tender_lines_on_tender_id"
    t.index ["variety_id"], name: "index_tender_lines_on_variety_id"
  end

  create_table "tenders", force: :cascade do |t|
    t.bigint "customer_id"
    t.boolean "approved", default: false
    t.datetime "date_start"
    t.datetime "date_end"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["customer_id"], name: "index_tenders_on_customer_id"
  end

  create_table "varieties", force: :cascade do |t|
    t.bigint "product_id"
    t.bigint "supplier_id"
    t.string "name"
    t.boolean "approved", default: false
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["product_id"], name: "index_varieties_on_product_id"
    t.index ["supplier_id"], name: "index_varieties_on_supplier_id"
  end

end
