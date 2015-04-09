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

ActiveRecord::Schema.define(version: 20150408083121) do

  # These are extensions that must be enabled in order to support this database
  enable_extension "plpgsql"

  create_table "active_admin_comments", force: :cascade do |t|
    t.string   "namespace"
    t.text     "body"
    t.string   "resource_id",   null: false
    t.string   "resource_type", null: false
    t.integer  "author_id"
    t.string   "author_type"
    t.datetime "created_at",    null: false
    t.datetime "updated_at",    null: false
  end

  add_index "active_admin_comments", ["author_type", "author_id"], name: "index_active_admin_comments_on_author_type_and_author_id", using: :btree
  add_index "active_admin_comments", ["namespace"], name: "index_active_admin_comments_on_namespace", using: :btree
  add_index "active_admin_comments", ["resource_type", "resource_id"], name: "index_active_admin_comments_on_resource_type_and_resource_id", using: :btree

  create_table "admin_users", force: :cascade do |t|
    t.string   "name",                   default: "", null: false
    t.string   "email",                  default: "", null: false
    t.string   "encrypted_password",     default: "", null: false
    t.string   "reset_password_token"
    t.datetime "reset_password_sent_at"
    t.datetime "remember_created_at"
    t.integer  "sign_in_count",          default: 0,  null: false
    t.datetime "current_sign_in_at"
    t.datetime "last_sign_in_at"
    t.inet     "current_sign_in_ip"
    t.inet     "last_sign_in_ip"
    t.string   "confirmation_token"
    t.datetime "confirmed_at"
    t.datetime "confirmation_sent_at"
    t.string   "unconfirmed_email"
    t.integer  "failed_attempts",        default: 0,  null: false
    t.string   "unlock_token"
    t.datetime "locked_at"
    t.datetime "created_at",                          null: false
    t.datetime "updated_at",                          null: false
  end

  add_index "admin_users", ["confirmation_token"], name: "index_admin_users_on_confirmation_token", unique: true, using: :btree
  add_index "admin_users", ["email"], name: "index_admin_users_on_email", unique: true, using: :btree
  add_index "admin_users", ["reset_password_token"], name: "index_admin_users_on_reset_password_token", unique: true, using: :btree
  add_index "admin_users", ["unlock_token"], name: "index_admin_users_on_unlock_token", unique: true, using: :btree

  create_table "campaigns", force: :cascade do |t|
    t.string   "name",        null: false
    t.date     "start"
    t.date     "finish"
    t.text     "description"
    t.datetime "created_at",  null: false
    t.datetime "updated_at",  null: false
  end

  create_table "campaigns_offers", id: false, force: :cascade do |t|
    t.integer "campaign_id", null: false
    t.integer "offer_id",    null: false
  end

  add_index "campaigns_offers", ["campaign_id", "offer_id"], name: "index_campaigns_offers_on_campaign_id_and_offer_id", unique: true, using: :btree

  create_table "configurations", force: :cascade do |t|
    t.string   "key",                     null: false
    t.text     "value"
    t.string   "form_type",               null: false
    t.string   "form_collection_command"
    t.datetime "created_at",              null: false
    t.datetime "updated_at",              null: false
  end

  add_index "configurations", ["key"], name: "index_configurations_on_key", unique: true, using: :btree

  create_table "customers", force: :cascade do |t|
    t.string   "name",       null: false
    t.string   "email"
    t.string   "phone"
    t.text     "address"
    t.string   "country"
    t.string   "postcode"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
  end

  create_table "customers_discounts", id: false, force: :cascade do |t|
    t.integer "discount_id", null: false
    t.integer "customer_id", null: false
    t.string  "reference"
    t.date    "expiry"
  end

  add_index "customers_discounts", ["customer_id", "discount_id"], name: "index_customers_discounts_on_customer_id_and_discount_id", unique: true, using: :btree

  create_table "customers_publications", id: false, force: :cascade do |t|
    t.integer "publication_id", null: false
    t.integer "customer_id",    null: false
    t.date    "subscribed",     null: false
    t.date    "expiry"
  end

  add_index "customers_publications", ["customer_id", "publication_id"], name: "index_customers_publications_on_customer_id_and_publication_id", unique: true, using: :btree

  create_table "discounts", force: :cascade do |t|
    t.string   "name",        null: false
    t.boolean  "requestable"
    t.datetime "created_at",  null: false
    t.datetime "updated_at",  null: false
  end

  add_index "discounts", ["name"], name: "index_discounts_on_name", unique: true, using: :btree

  create_table "offers", force: :cascade do |t|
    t.string   "name",        null: false
    t.date     "expiry"
    t.text     "description"
    t.datetime "created_at",  null: false
    t.datetime "updated_at",  null: false
  end

  create_table "offers_products", id: false, force: :cascade do |t|
    t.integer "product_id", null: false
    t.integer "offer_id",   null: false
    t.boolean "optional"
  end

  add_index "offers_products", ["offer_id", "product_id"], name: "index_offers_products_on_offer_id_and_product_id", unique: true, using: :btree

  create_table "offers_publications", id: false, force: :cascade do |t|
    t.integer "publication_id", null: false
    t.integer "offer_id",       null: false
    t.integer "quantity"
    t.string  "unit"
  end

  add_index "offers_publications", ["offer_id", "publication_id"], name: "index_offers_publications_on_offer_id_and_publication_id", unique: true, using: :btree

  create_table "products", force: :cascade do |t|
    t.string   "name",               null: false
    t.integer  "stock"
    t.string   "image_file_name"
    t.string   "image_content_type"
    t.integer  "image_file_size"
    t.datetime "image_updated_at"
    t.text     "description"
    t.datetime "created_at",         null: false
    t.datetime "updated_at",         null: false
  end

  add_index "products", ["name"], name: "index_products_on_name", unique: true, using: :btree

  create_table "publications", force: :cascade do |t|
    t.string   "name",               null: false
    t.string   "website",            null: false
    t.string   "image_file_name"
    t.string   "image_content_type"
    t.integer  "image_file_size"
    t.datetime "image_updated_at"
    t.text     "description"
    t.datetime "created_at",         null: false
    t.datetime "updated_at",         null: false
  end

  add_index "publications", ["name"], name: "index_publications_on_name", unique: true, using: :btree

end
