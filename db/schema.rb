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

ActiveRecord::Schema.define(version: 2020_07_26_102204) do

  # These are extensions that must be enabled in order to support this database
  enable_extension "plpgsql"

  create_table "categories", force: :cascade do |t|
    t.string "name"
    t.bigint "items_id"
    t.index ["items_id"], name: "index_categories_on_items_id"
  end

  create_table "friendly_id_slugs", force: :cascade do |t|
    t.string "slug", null: false
    t.integer "sluggable_id", null: false
    t.string "sluggable_type", limit: 50
    t.string "scope"
    t.datetime "created_at"
    t.index ["slug", "sluggable_type", "scope"], name: "index_friendly_id_slugs_on_slug_and_sluggable_type_and_scope", unique: true
    t.index ["slug", "sluggable_type"], name: "index_friendly_id_slugs_on_slug_and_sluggable_type"
    t.index ["sluggable_type", "sluggable_id"], name: "index_friendly_id_slugs_on_sluggable_type_and_sluggable_id"
  end

  create_table "items", force: :cascade do |t|
    t.string "torn_id"
    t.string "name"
    t.bigint "base_price"
    t.bigint "category_id"
    t.string "image_url", default: "null"
    t.string "description", default: "null"
    t.integer "item_type", default: 0
    t.string "thumbnail_url"
    t.datetime "base_price_added_on"
    t.bigint "lowest_market_price", default: 0
    t.datetime "lowest_price_added_on"
    t.bigint "average_market_price", default: 0
    t.index ["category_id"], name: "index_items_on_category_id"
    t.index ["name"], name: "index_items_on_name"
  end

  create_table "line_items", force: :cascade do |t|
    t.integer "quantity", default: 0
    t.bigint "trade_id"
    t.bigint "total", default: 0
    t.bigint "item_id"
    t.index ["item_id"], name: "index_line_items_on_item_id"
    t.index ["trade_id"], name: "index_line_items_on_trade_id"
  end

  create_table "messages", force: :cascade do |t|
    t.string "message", default: "", null: false
    t.bigint "user_id"
    t.string "name"
    t.index ["user_id"], name: "index_messages_on_user_id"
  end

  create_table "points", force: :cascade do |t|
    t.datetime "created_at", precision: 6, null: false
    t.datetime "updated_at", precision: 6, null: false
    t.integer "price"
  end

  create_table "positions", force: :cascade do |t|
    t.integer "number"
    t.bigint "user_id"
    t.bigint "category_id"
    t.index ["category_id"], name: "index_positions_on_category_id"
    t.index ["user_id"], name: "index_positions_on_user_id"
  end

  create_table "prices", force: :cascade do |t|
    t.datetime "created_at", precision: 6, null: false
    t.datetime "updated_at", precision: 6, null: false
    t.bigint "user_id"
    t.bigint "item_id"
    t.bigint "amount"
    t.integer "auto_update", default: 0
    t.integer "pricing_rule", default: 0
    t.datetime "price_updated_at"
    t.integer "profit_percentage", default: 1
    t.bigint "category_id"
    t.bigint "line_item_id"
    t.index ["category_id"], name: "index_prices_on_category_id"
    t.index ["item_id"], name: "index_prices_on_item_id"
    t.index ["line_item_id"], name: "index_prices_on_line_item_id"
    t.index ["user_id"], name: "index_prices_on_user_id"
  end

  create_table "subscriptions", force: :cascade do |t|
    t.datetime "created_at", precision: 6, null: false
    t.datetime "updated_at", precision: 6, null: false
    t.datetime "ends_at", null: false
    t.bigint "user_id"
    t.integer "state", default: 0
    t.integer "pricelist_type", default: 0
    t.index ["user_id"], name: "index_subscriptions_on_user_id"
  end

  create_table "trades", force: :cascade do |t|
    t.datetime "created_at", precision: 6, null: false
    t.datetime "updated_at", precision: 6, null: false
    t.bigint "user_id"
    t.bigint "total", default: 0
    t.string "slug"
    t.integer "torn_trade_id"
    t.string "seller"
    t.string "short_url"
    t.index ["slug"], name: "index_trades_on_slug", unique: true
    t.index ["user_id"], name: "index_trades_on_user_id"
  end

  create_table "users", force: :cascade do |t|
    t.string "email", default: "", null: false
    t.string "encrypted_password", default: "", null: false
    t.string "reset_password_token"
    t.datetime "reset_password_sent_at"
    t.datetime "remember_created_at"
    t.datetime "created_at", precision: 6, null: false
    t.datetime "updated_at", precision: 6, null: false
    t.string "torn_api_key"
    t.string "torn_user_id"
    t.string "username"
    t.boolean "price_list", default: false
    t.string "forum_url"
    t.datetime "updated_price_list_at"
    t.string "custom_message"
    t.integer "user_type", default: 0
    t.string "trader_api_token"
    t.datetime "trader_api_token_update_at"
    t.integer "auto_update", default: 0
    t.integer "pricing_rule", default: 0
    t.integer "amount", default: 0
    t.integer "global_pricing", default: 0
    t.string "short_pricelist_url"
    t.string "message"
    t.integer "theme", default: 0
    t.string "backgroundColor"
    t.index ["reset_password_token"], name: "index_users_on_reset_password_token", unique: true
  end

end
