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

ActiveRecord::Schema.define(version: 20171219024720) do

  create_table "categories", force: :cascade, options: "ENGINE=InnoDB DEFAULT CHARSET=utf8" do |t|
    t.string "style"
    t.bigint "user_id"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["user_id"], name: "index_categories_on_user_id"
  end

  create_table "coin_values", force: :cascade, options: "ENGINE=InnoDB DEFAULT CHARSET=utf8" do |t|
    t.decimal "cost_per_coin", precision: 10
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.string "type_buy"
  end

  create_table "comments", force: :cascade, options: "ENGINE=InnoDB DEFAULT CHARSET=utf8" do |t|
    t.string "content"
    t.bigint "user_id"
    t.bigint "document_id"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.integer "reply_id"
    t.boolean "is_report", default: false
    t.index ["document_id"], name: "index_comments_on_document_id"
    t.index ["user_id"], name: "index_comments_on_user_id"
  end

  create_table "documents", force: :cascade, options: "ENGINE=InnoDB DEFAULT CHARSET=utf8" do |t|
    t.bigint "user_id"
    t.bigint "category_id"
    t.string "content"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.string "name_document"
    t.datetime "deleted_at"
    t.boolean "is_illegal", default: false
    t.index ["category_id"], name: "index_documents_on_category_id"
    t.index ["deleted_at"], name: "index_documents_on_deleted_at"
    t.index ["user_id", "created_at"], name: "index_documents_on_user_id_and_created_at"
    t.index ["user_id"], name: "index_documents_on_user_id"
  end

  create_table "favorites", force: :cascade, options: "ENGINE=InnoDB DEFAULT CHARSET=utf8" do |t|
    t.bigint "user_id"
    t.bigint "document_id"
    t.boolean "is_favorite", default: false
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["document_id"], name: "index_favorites_on_document_id"
    t.index ["user_id"], name: "index_favorites_on_user_id"
  end

  create_table "friends", force: :cascade, options: "ENGINE=InnoDB DEFAULT CHARSET=utf8" do |t|
    t.boolean "is_accept", default: false
    t.integer "sender_id"
    t.integer "accepter_id"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["accepter_id"], name: "index_friends_on_accepter_id"
    t.index ["sender_id", "accepter_id"], name: "index_friends_on_sender_id_and_accepter_id", unique: true
    t.index ["sender_id"], name: "index_friends_on_sender_id"
  end

  create_table "history_downloads", force: :cascade, options: "ENGINE=InnoDB DEFAULT CHARSET=utf8" do |t|
    t.bigint "user_id"
    t.bigint "document_id"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["document_id"], name: "index_history_downloads_on_document_id"
    t.index ["user_id"], name: "index_history_downloads_on_user_id"
  end

  create_table "history_views", force: :cascade, options: "ENGINE=InnoDB DEFAULT CHARSET=utf8" do |t|
    t.bigint "user_id"
    t.bigint "document_id"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["document_id"], name: "index_history_views_on_document_id"
    t.index ["user_id"], name: "index_history_views_on_user_id"
  end

  create_table "transactions", force: :cascade, options: "ENGINE=InnoDB DEFAULT CHARSET=utf8" do |t|
    t.bigint "user_id"
    t.integer "coin"
    t.decimal "cost_at_buy", precision: 10
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.boolean "is_confirm", default: false
    t.datetime "deleted_at"
    t.index ["deleted_at"], name: "index_transactions_on_deleted_at"
    t.index ["user_id", "created_at"], name: "index_transactions_on_user_id_and_created_at"
    t.index ["user_id"], name: "index_transactions_on_user_id"
  end

  create_table "users", force: :cascade, options: "ENGINE=InnoDB DEFAULT CHARSET=utf8" do |t|
    t.string "name"
    t.string "email"
    t.integer "coin"
    t.boolean "is_admin", default: false
    t.string "password_digest"
    t.integer "down_count"
    t.integer "up_count"
    t.datetime "login_last_at"
    t.string "avatar"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.string "remember_digest"
    t.string "encrypted_password", default: "", null: false
    t.string "reset_password_token"
    t.datetime "reset_password_sent_at"
    t.datetime "remember_created_at"
    t.integer "sign_in_count", default: 0, null: false
    t.datetime "current_sign_in_at"
    t.datetime "last_sign_in_at"
    t.string "current_sign_in_ip"
    t.string "last_sign_in_ip"
    t.string "confirmation_token"
    t.datetime "confirmed_at"
    t.datetime "confirmation_sent_at"
    t.string "unconfirmed_email"
    t.index ["email"], name: "index_users_on_email", unique: true
    t.index ["name"], name: "index_users_on_name"
    t.index ["reset_password_token"], name: "index_users_on_reset_password_token", unique: true
  end

end
