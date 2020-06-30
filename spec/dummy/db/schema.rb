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

ActiveRecord::Schema.define(version: 2020_04_21_223602) do

  # These are extensions that must be enabled in order to support this database
  enable_extension "plpgsql"

  create_table "ckeditor_assets", id: :serial, force: :cascade do |t|
    t.string "data_file_name", null: false
    t.string "data_content_type"
    t.integer "data_file_size"
    t.integer "assetable_id"
    t.string "assetable_type", limit: 30
    t.string "type", limit: 30
    t.integer "width"
    t.integer "height"
    t.datetime "created_at"
    t.datetime "updated_at"
    t.index ["assetable_type", "assetable_id"], name: "idx_ckeditor_assetable"
    t.index ["assetable_type", "type", "assetable_id"], name: "idx_ckeditor_assetable_type"
  end

  create_table "friendly_id_slugs", id: :serial, force: :cascade do |t|
    t.string "slug", null: false
    t.integer "sluggable_id", null: false
    t.string "sluggable_type", limit: 50
    t.string "scope"
    t.datetime "created_at"
    t.index ["slug", "sluggable_type", "scope"], name: "index_friendly_id_slugs_on_slug_and_sluggable_type_and_scope", unique: true
    t.index ["slug", "sluggable_type"], name: "index_friendly_id_slugs_on_slug_and_sluggable_type"
    t.index ["sluggable_id"], name: "index_friendly_id_slugs_on_sluggable_id"
    t.index ["sluggable_type"], name: "index_friendly_id_slugs_on_sluggable_type"
  end

  create_table "integral_categories", force: :cascade do |t|
    t.string "title"
    t.string "description"
    t.string "slug"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.bigint "image_id"
    t.index ["image_id"], name: "index_integral_categories_on_image_id"
  end

  create_table "integral_category_versions", force: :cascade do |t|
    t.string "item_type", null: false
    t.integer "item_id", null: false
    t.string "event", null: false
    t.string "whodunnit"
    t.text "object"
    t.text "object_changes"
    t.datetime "created_at"
    t.index ["item_type", "item_id"], name: "index_integral_category_versions_on_item_type_and_item_id"
  end

  create_table "integral_enquiries", id: :serial, force: :cascade do |t|
    t.string "name"
    t.string "email"
    t.string "subject"
    t.text "message"
    t.datetime "deleted_at"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.boolean "processed", default: false
    t.boolean "newsletter_opt_in", default: true
    t.string "context"
  end

  create_table "integral_image_versions", force: :cascade do |t|
    t.string "item_type", null: false
    t.integer "item_id", null: false
    t.string "event", null: false
    t.string "whodunnit"
    t.text "object"
    t.text "object_changes"
    t.datetime "created_at"
    t.index ["item_type", "item_id"], name: "index_integral_image_versions_on_item_type_and_item_id"
  end

  create_table "integral_images", id: :serial, force: :cascade do |t|
    t.string "title"
    t.string "description"
    t.string "file"
    t.integer "width"
    t.integer "height"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.datetime "deleted_at"
    t.boolean "file_processing", default: true, null: false
    t.integer "file_size"
    t.integer "lock_version"
    t.index ["deleted_at"], name: "index_integral_images_on_deleted_at"
  end

  create_table "integral_list_item_connections", id: false, force: :cascade do |t|
    t.integer "parent_id", null: false
    t.integer "child_id", null: false
  end

  create_table "integral_list_items", id: :serial, force: :cascade do |t|
    t.integer "list_id"
    t.string "title"
    t.text "description"
    t.string "subtitle"
    t.string "url"
    t.integer "image_id"
    t.string "target"
    t.string "html_classes"
    t.integer "priority"
    t.integer "object_id"
    t.string "type"
    t.string "object_type"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  create_table "integral_list_versions", id: :serial, force: :cascade do |t|
    t.string "item_type", null: false
    t.integer "item_id", null: false
    t.string "event", null: false
    t.string "whodunnit"
    t.text "object"
    t.text "object_changes"
    t.datetime "created_at"
    t.index ["item_type", "item_id"], name: "index_integral_list_versions_on_item_type_and_item_id"
  end

  create_table "integral_lists", id: :serial, force: :cascade do |t|
    t.string "title", null: false
    t.text "description"
    t.boolean "locked"
    t.string "html_classes"
    t.string "html_id"
    t.datetime "created_at"
    t.datetime "updated_at"
    t.datetime "deleted_at"
    t.integer "lock_version"
    t.integer "list_item_limit", default: 0
    t.boolean "hidden", default: false
    t.boolean "children", default: false
    t.index ["deleted_at"], name: "index_integral_lists_on_deleted_at"
  end

  create_table "integral_newsletter_signups", force: :cascade do |t|
    t.string "email"
    t.string "name"
    t.string "context"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.boolean "processed", default: false
  end

  create_table "integral_notification_subscriptions", force: :cascade do |t|
    t.integer "user_id"
    t.string "state"
    t.string "subscribable_type"
    t.bigint "subscribable_id"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["subscribable_type", "subscribable_id"], name: "index_integral_subscriptions_on_subscribable_type_id"
  end

  create_table "integral_notifications", force: :cascade do |t|
    t.integer "recipient_id"
    t.integer "actor_id"
    t.datetime "read_at"
    t.string "action"
    t.string "subscribable_type"
    t.bigint "subscribable_id"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["subscribable_type", "subscribable_id"], name: "index_integral_notifications_on_subscribable_type_id"
  end

  create_table "integral_page_versions", id: :serial, force: :cascade do |t|
    t.string "item_type", null: false
    t.integer "item_id", null: false
    t.string "event", null: false
    t.string "whodunnit"
    t.text "object"
    t.text "object_changes"
    t.datetime "created_at"
    t.index ["item_type", "item_id"], name: "index_integral_page_versions_on_item_type_and_item_id"
  end

  create_table "integral_pages", id: :serial, force: :cascade do |t|
    t.string "title"
    t.string "path"
    t.text "description"
    t.text "body"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.integer "status", default: 0, null: false
    t.datetime "deleted_at"
    t.string "template", default: "default"
    t.integer "parent_id"
    t.integer "image_id"
    t.integer "lock_version"
    t.index ["deleted_at"], name: "index_integral_pages_on_deleted_at"
    t.index ["image_id"], name: "index_integral_pages_on_image_id"
  end

  create_table "integral_post_versions", id: :serial, force: :cascade do |t|
    t.string "item_type", null: false
    t.integer "item_id", null: false
    t.string "event", null: false
    t.string "whodunnit"
    t.text "object"
    t.text "object_changes"
    t.datetime "created_at"
    t.index ["item_type", "item_id"], name: "index_integral_post_versions_on_item_type_and_item_id"
  end

  create_table "integral_post_viewings", id: :serial, force: :cascade do |t|
    t.integer "post_id"
    t.string "ip_address"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["post_id"], name: "index_integral_post_viewings_on_post_id"
  end

  create_table "integral_posts", id: :serial, force: :cascade do |t|
    t.string "title"
    t.string "description"
    t.text "body"
    t.integer "user_id"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.string "slug"
    t.integer "view_count", default: 0
    t.datetime "published_at"
    t.integer "status", default: 0, null: false
    t.datetime "deleted_at"
    t.integer "image_id"
    t.integer "lock_version"
    t.integer "preview_image_id"
    t.bigint "category_id"
    t.index ["category_id"], name: "index_integral_posts_on_category_id"
    t.index ["deleted_at"], name: "index_integral_posts_on_deleted_at"
    t.index ["image_id"], name: "index_integral_posts_on_image_id"
    t.index ["preview_image_id"], name: "index_integral_posts_on_preview_image_id"
    t.index ["slug"], name: "index_integral_posts_on_slug", unique: true
    t.index ["user_id"], name: "index_integral_posts_on_user_id"
  end

  create_table "integral_role_assignments", id: :serial, force: :cascade do |t|
    t.integer "user_id"
    t.integer "role_id"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["role_id"], name: "index_integral_role_assignments_on_role_id"
    t.index ["user_id"], name: "index_integral_role_assignments_on_user_id"
  end

  create_table "integral_roles", id: :serial, force: :cascade do |t|
    t.string "name"
  end

  create_table "integral_user_versions", id: :serial, force: :cascade do |t|
    t.string "item_type", null: false
    t.integer "item_id", null: false
    t.string "event", null: false
    t.string "whodunnit"
    t.text "object"
    t.text "object_changes"
    t.datetime "created_at"
    t.index ["item_type", "item_id"], name: "index_integral_user_versions_on_item_type_and_item_id"
  end

  create_table "integral_users", id: :serial, force: :cascade do |t|
    t.string "email", default: "", null: false
    t.string "encrypted_password", default: "", null: false
    t.string "reset_password_token"
    t.datetime "reset_password_sent_at"
    t.datetime "remember_created_at"
    t.integer "sign_in_count", default: 0, null: false
    t.datetime "current_sign_in_at"
    t.datetime "last_sign_in_at"
    t.string "current_sign_in_ip"
    t.string "last_sign_in_ip"
    t.datetime "created_at"
    t.datetime "updated_at"
    t.string "name"
    t.string "avatar"
    t.string "locale", default: "en", null: false
    t.string "invitation_token"
    t.datetime "invitation_created_at"
    t.datetime "invitation_sent_at"
    t.datetime "invitation_accepted_at"
    t.integer "invitation_limit"
    t.string "invited_by_type"
    t.integer "invited_by_id"
    t.integer "invitations_count", default: 0
    t.datetime "deleted_at"
    t.boolean "avatar_processing", default: true, null: false
    t.integer "lock_version"
    t.boolean "admin", default: false
    t.boolean "notify_me", default: true
    t.integer "status", default: 0
    t.index ["deleted_at"], name: "index_integral_users_on_deleted_at"
    t.index ["email"], name: "index_integral_users_on_email", unique: true
    t.index ["invitation_token"], name: "index_integral_users_on_invitation_token", unique: true
    t.index ["invitations_count"], name: "index_integral_users_on_invitations_count"
    t.index ["invited_by_id"], name: "index_integral_users_on_invited_by_id"
    t.index ["reset_password_token"], name: "index_integral_users_on_reset_password_token", unique: true
  end

  create_table "integral_webhook_endpoints", force: :cascade do |t|
    t.string "target_url", null: false
    t.string "events", null: false, array: true
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["events"], name: "index_integral_webhook_endpoints_on_events"
  end

  create_table "settings", id: :serial, force: :cascade do |t|
    t.string "var", null: false
    t.text "value"
    t.integer "thing_id"
    t.string "thing_type", limit: 30
    t.datetime "created_at"
    t.datetime "updated_at"
    t.index ["thing_type", "thing_id", "var"], name: "index_settings_on_thing_type_and_thing_id_and_var", unique: true
  end

  create_table "taggings", id: :serial, force: :cascade do |t|
    t.integer "tag_id"
    t.string "taggable_type"
    t.integer "taggable_id"
    t.string "tagger_type"
    t.integer "tagger_id"
    t.string "context", limit: 128
    t.datetime "created_at"
    t.index ["tag_id", "taggable_id", "taggable_type", "context", "tagger_id", "tagger_type"], name: "taggings_idx", unique: true
    t.index ["taggable_id", "taggable_type", "context"], name: "index_taggings_on_taggable_id_and_taggable_type_and_context"
  end

  create_table "tags", id: :serial, force: :cascade do |t|
    t.string "name"
    t.integer "taggings_count", default: 0
    t.index ["name"], name: "index_tags_on_name", unique: true
  end

end
