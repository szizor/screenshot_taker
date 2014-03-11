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

ActiveRecord::Schema.define(:version => 20130710202501) do

  create_table "delayed_jobs", :force => true do |t|
    t.integer  "priority",   :default => 0
    t.integer  "attempts",   :default => 0
    t.text     "handler"
    t.text     "last_error"
    t.datetime "run_at"
    t.datetime "locked_at"
    t.datetime "failed_at"
    t.string   "locked_by"
    t.datetime "created_at"
    t.datetime "updated_at"
    t.string   "queue"
  end

  add_index "delayed_jobs", ["priority", "run_at"], :name => "delayed_jobs_priority"

  create_table "photos", :force => true do |t|
    t.string   "source"
    t.string   "source_author_profile"
    t.string   "source_id"
    t.string   "source_image_id"
    t.string   "source_author_username"
    t.string   "source_image"
    t.string   "licence_type"
    t.string   "licence_url"
    t.string   "image_name"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  create_table "productshots", :force => true do |t|
    t.string   "name"
    t.string   "image"
    t.datetime "created_at"
    t.datetime "updated_at"
    t.string   "image_high"
  end

  create_table "purchases", :force => true do |t|
    t.string   "first_name",                  :null => false
    t.string   "last_name",                   :null => false
    t.string   "email",       :default => "", :null => false
    t.string   "customer_id"
    t.integer  "plan_id"
    t.datetime "created_at",                  :null => false
    t.datetime "updated_at",                  :null => false
  end

  add_index "purchases", ["email"], :name => "index_purcharses_on_email"

  create_table "screens", :force => true do |t|
    t.string   "name"
    t.string   "url"
    t.boolean  "processed",       :default => false
    t.integer  "installation_id"
    t.integer  "sitemap_id"
    t.string   "image_path"
    t.datetime "created_at",                         :null => false
    t.datetime "updated_at",                         :null => false
  end

  create_table "shared_images", :force => true do |t|
    t.string   "slug"
    t.string   "url"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  create_table "sitemaps", :force => true do |t|
    t.string   "url"
    t.boolean  "processed",  :default => false
    t.datetime "created_at",                    :null => false
    t.datetime "updated_at",                    :null => false
  end

  create_table "stages", :force => true do |t|
    t.string   "name"
    t.text     "content"
    t.string   "stage_image"
    t.string   "output_image"
    t.datetime "created_at"
    t.datetime "updated_at"
    t.string   "composite"
    t.string   "glare_image"
    t.boolean  "published"
    t.integer  "position"
    t.string   "viewport",     :default => "1280x1024"
    t.string   "bg_less"
  end

  create_table "taggings", :force => true do |t|
    t.integer  "tag_id"
    t.integer  "taggable_id"
    t.string   "taggable_type"
    t.integer  "tagger_id"
    t.string   "tagger_type"
    t.string   "context",       :limit => 128
    t.datetime "created_at"
  end

  add_index "taggings", ["tag_id"], :name => "index_taggings_on_tag_id"
  add_index "taggings", ["taggable_id", "taggable_type", "context"], :name => "index_taggings_on_taggable_id_and_taggable_type_and_context"

  create_table "tags", :force => true do |t|
    t.string "name", :null => false
  end

  create_table "user_sessions", :force => true do |t|
    t.datetime "created_at", :null => false
    t.datetime "updated_at", :null => false
  end

  create_table "users", :force => true do |t|
    t.string   "username"
    t.string   "email"
    t.string   "crypted_password"
    t.string   "password_salt"
    t.string   "persistence_token"
    t.datetime "created_at"
    t.datetime "updated_at"
    t.boolean  "is_admin",          :default => false
    t.string   "password_digest"
  end

end
