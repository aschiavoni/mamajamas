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
# It's strongly recommended to check this file into your version control system.

ActiveRecord::Schema.define(:version => 20130102180822) do

  create_table "categories", :force => true do |t|
    t.string   "name"
    t.datetime "created_at", :null => false
    t.datetime "updated_at", :null => false
    t.string   "slug"
  end

  add_index "categories", ["slug"], :name => "index_categories_on_slug", :unique => true

  create_table "list_items", :force => true do |t|
    t.integer  "list_id"
    t.string   "name"
    t.boolean  "owned"
    t.string   "link"
    t.integer  "rating"
    t.integer  "priority"
    t.string   "notes"
    t.string   "image_url"
    t.datetime "created_at",                :null => false
    t.datetime "updated_at",                :null => false
    t.integer  "product_type_id"
    t.integer  "category_id"
    t.integer  "when_to_buy_suggestion_id"
  end

  add_index "list_items", ["category_id"], :name => "index_list_items_on_category_id"
  add_index "list_items", ["list_id"], :name => "index_list_items_on_list_id"

  create_table "list_product_types", :force => true do |t|
    t.integer  "list_id"
    t.integer  "product_type_id"
    t.integer  "category_id"
    t.datetime "created_at",                         :null => false
    t.datetime "updated_at",                         :null => false
    t.boolean  "hidden",          :default => false
  end

  add_index "list_product_types", ["category_id"], :name => "index_list_product_types_on_category_id"
  add_index "list_product_types", ["list_id"], :name => "index_list_product_types_on_list_id"
  add_index "list_product_types", ["product_type_id"], :name => "index_list_product_types_on_product_type_id"

  create_table "lists", :force => true do |t|
    t.string   "title"
    t.integer  "user_id"
    t.datetime "created_at", :null => false
    t.datetime "updated_at", :null => false
  end

  add_index "lists", ["user_id"], :name => "index_lists_on_user_id"

  create_table "product_type_queries", :force => true do |t|
    t.integer  "product_type_id"
    t.string   "query"
    t.datetime "created_at",      :null => false
    t.datetime "updated_at",      :null => false
  end

  add_index "product_type_queries", ["product_type_id"], :name => "index_product_type_queries_on_product_type_id"

  create_table "product_types", :force => true do |t|
    t.integer  "category_id"
    t.string   "name"
    t.integer  "priority"
    t.datetime "created_at",                :null => false
    t.datetime "updated_at",                :null => false
    t.string   "slug"
    t.string   "image_name"
    t.integer  "when_to_buy_suggestion_id"
    t.integer  "user_id"
  end

  add_index "product_types", ["category_id"], :name => "index_product_types_on_category_id"
  add_index "product_types", ["slug"], :name => "index_product_types_on_slug", :unique => true

  create_table "product_types_products", :force => true do |t|
    t.integer "product_type_id"
    t.integer "product_id"
  end

  create_table "products", :force => true do |t|
    t.string   "vendor_id"
    t.string   "vendor"
    t.string   "name"
    t.string   "url"
    t.integer  "rating"
    t.datetime "created_at", :null => false
    t.datetime "updated_at", :null => false
    t.string   "image_url"
  end

  create_table "relationships", :force => true do |t|
    t.integer  "follower_id"
    t.integer  "followed_id"
    t.datetime "created_at",                :null => false
    t.datetime "updated_at",                :null => false
    t.datetime "delivered_notification_at"
  end

  add_index "relationships", ["followed_id"], :name => "index_relationships_on_followed_id"
  add_index "relationships", ["follower_id", "followed_id"], :name => "index_relationships_on_follower_id_and_followed_id", :unique => true
  add_index "relationships", ["follower_id"], :name => "index_relationships_on_follower_id"

  create_table "users", :force => true do |t|
    t.string   "username",                    :default => "", :null => false
    t.string   "email",                       :default => "", :null => false
    t.string   "encrypted_password",          :default => "", :null => false
    t.string   "reset_password_token"
    t.datetime "reset_password_sent_at"
    t.datetime "remember_created_at"
    t.integer  "sign_in_count",               :default => 0
    t.datetime "current_sign_in_at"
    t.datetime "last_sign_in_at"
    t.string   "current_sign_in_ip"
    t.string   "last_sign_in_ip"
    t.string   "confirmation_token"
    t.datetime "confirmed_at"
    t.datetime "confirmation_sent_at"
    t.string   "unconfirmed_email"
    t.datetime "created_at",                                  :null => false
    t.datetime "updated_at",                                  :null => false
    t.string   "provider"
    t.string   "uid"
    t.string   "access_token"
    t.datetime "access_token_expires_at"
    t.string   "first_name"
    t.string   "last_name"
    t.text     "facebook_friends"
    t.datetime "facebook_friends_updated_at"
  end

  add_index "users", ["confirmation_token"], :name => "index_users_on_confirmation_token", :unique => true
  add_index "users", ["email"], :name => "index_users_on_email", :unique => true
  add_index "users", ["reset_password_token"], :name => "index_users_on_reset_password_token", :unique => true
  add_index "users", ["username"], :name => "index_users_on_username", :unique => true

  create_table "when_to_buy_suggestions", :force => true do |t|
    t.string   "name"
    t.integer  "position"
    t.datetime "created_at", :null => false
    t.datetime "updated_at", :null => false
  end

end
