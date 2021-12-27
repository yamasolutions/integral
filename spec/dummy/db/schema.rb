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

ActiveRecord::Schema.define(version: 2021_06_15_194128) do

  # These are extensions that must be enabled in order to support this database
  enable_extension "plpgsql"

  create_table "active_storage_attachments", force: :cascade do |t|
    t.string "name", null: false
    t.string "record_type", null: false
    t.bigint "record_id", null: false
    t.bigint "blob_id", null: false
    t.datetime "created_at", null: false
    t.index ["blob_id"], name: "index_active_storage_attachments_on_blob_id"
    t.index ["record_type", "record_id", "name", "blob_id"], name: "index_active_storage_attachments_uniqueness", unique: true
  end

  create_table "active_storage_blobs", force: :cascade do |t|
    t.string "key", null: false
    t.string "filename", null: false
    t.string "content_type"
    t.text "metadata"
    t.string "service_name", null: false
    t.bigint "byte_size", null: false
    t.string "checksum", null: false
    t.datetime "created_at", null: false
    t.index ["key"], name: "index_active_storage_blobs_on_key", unique: true
  end

  create_table "active_storage_variant_records", force: :cascade do |t|
    t.bigint "blob_id", null: false
    t.string "variation_digest", null: false
    t.index ["blob_id", "variation_digest"], name: "index_active_storage_variant_records_uniqueness", unique: true
  end

  create_table "block_editor_block_list_connections", force: :cascade do |t|
    t.bigint "parent_id"
    t.bigint "child_id"
    t.index ["child_id"], name: "index_block_editor_block_list_connections_on_child_id"
    t.index ["parent_id"], name: "index_block_editor_block_list_connections_on_parent_id"
  end

  create_table "block_editor_block_lists", force: :cascade do |t|
    t.string "name"
    t.text "content"
    t.boolean "active", default: false
    t.string "listable_type"
    t.bigint "listable_id"
    t.datetime "created_at", precision: 6, null: false
    t.datetime "updated_at", precision: 6, null: false
    t.index ["listable_type", "listable_id"], name: "index_block_editor_block_lists_on_listable"
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

  create_table "integral_block_list_versions", force: :cascade do |t|
    t.string "item_type", null: false
    t.integer "item_id", null: false
    t.string "event", null: false
    t.string "whodunnit"
    t.text "object"
    t.text "object_changes"
    t.datetime "created_at"
    t.index ["item_type", "item_id"], name: "index_integral_block_list_versions_on_item_type_and_item_id"
  end

  create_table "integral_block_lists", force: :cascade do |t|
    t.string "name"
    t.text "content"
    t.boolean "active", default: false
    t.string "listable_type"
    t.bigint "listable_id"
    t.datetime "created_at", precision: 6, null: false
    t.datetime "updated_at", precision: 6, null: false
    t.index ["listable_type", "listable_id"], name: "index_integral_block_lists_on_listable_type_and_listable_id"
  end

  create_table "integral_categories", force: :cascade do |t|
    t.string "title"
    t.string "description"
    t.string "slug"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.bigint "image_id"
    t.string "locale"
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

  create_table "integral_file_versions", force: :cascade do |t|
    t.string "item_type", null: false
    t.integer "item_id", null: false
    t.string "event", null: false
    t.string "whodunnit"
    t.text "object"
    t.text "object_changes"
    t.datetime "created_at"
    t.index ["item_type", "item_id"], name: "index_integral_file_versions_on_item_type_and_item_id"
  end

  create_table "integral_files", force: :cascade do |t|
    t.string "title"
    t.string "description"
    t.datetime "deleted_at"
    t.datetime "created_at", precision: 6, null: false
    t.datetime "updated_at", precision: 6, null: false
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
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.integer "status", default: 0, null: false
    t.datetime "deleted_at"
    t.string "template", default: "default"
    t.integer "parent_id"
    t.integer "image_id"
    t.integer "lock_version"
    t.string "locale"
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
    t.string "locale"
    t.index ["category_id"], name: "index_integral_posts_on_category_id"
    t.index ["deleted_at"], name: "index_integral_posts_on_deleted_at"
    t.index ["image_id"], name: "index_integral_posts_on_image_id"
    t.index ["preview_image_id"], name: "index_integral_posts_on_preview_image_id"
    t.index ["slug", "locale"], name: "index_integral_posts_on_slug_and_locale", unique: true
    t.index ["user_id"], name: "index_integral_posts_on_user_id"
  end

  create_table "integral_resource_alternates", force: :cascade do |t|
    t.string "alternate_type"
    t.bigint "alternate_id"
    t.string "resource_type"
    t.bigint "resource_id"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["resource_type", "resource_id"], name: "index_integral_resource_alternates_on_resource_type_id"
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

  add_foreign_key "active_storage_attachments", "active_storage_blobs", column: "blob_id"
  add_foreign_key "active_storage_variant_records", "active_storage_blobs", column: "blob_id"
end
