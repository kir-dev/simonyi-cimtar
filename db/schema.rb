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

ActiveRecord::Schema.define(:version => 20130203134318) do

  create_table "groups", :force => true do |t|
    t.string   "name"
    t.integer  "founded"
    t.string   "url"
    t.string   "mail_list"
    t.string   "shortname"
    t.datetime "created_at", :null => false
    t.datetime "updated_at", :null => false
  end

  create_table "job_positions", :force => true do |t|
    t.string   "company"
    t.string   "title"
    t.string   "location"
    t.date     "from_date"
    t.date     "to_date"
    t.boolean  "present_job"
    t.integer  "member_id"
    t.datetime "created_at",  :null => false
    t.datetime "updated_at",  :null => false
  end

  add_index "job_positions", ["member_id"], :name => "index_job_positions_on_member_id"

  create_table "member_posts", :force => true do |t|
    t.string   "title"
    t.datetime "from_date"
    t.datetime "to_date"
    t.boolean  "deleted",       :default => false
    t.integer  "membership_id"
    t.datetime "created_at",                       :null => false
    t.datetime "updated_at",                       :null => false
  end

  add_index "member_posts", ["membership_id"], :name => "index_member_posts_on_membership_id"

  create_table "member_roles", :force => true do |t|
    t.string   "name"
    t.integer  "group_id"
    t.datetime "created_at", :null => false
    t.datetime "updated_at", :null => false
  end

  add_index "member_roles", ["group_id"], :name => "index_member_roles_on_group_id"

  create_table "member_roles_members", :id => false, :force => true do |t|
    t.integer "member_id",      :null => false
    t.integer "member_role_id", :null => false
  end

  add_index "member_roles_members", ["member_id", "member_role_id"], :name => "index_member_roles_members_on_member_id_and_member_role_id"

  create_table "members", :force => true do |t|
    t.string   "full_name"
    t.string   "email"
    t.string   "phone"
    t.string   "room"
    t.string   "address"
    t.text     "intro"
    t.integer  "univ_year"
    t.integer  "enrollment_year"
    t.string   "hobby"
    t.boolean  "deleted",         :default => false
    t.string   "login"
    t.string   "nick"
    t.boolean  "admin",           :default => false
    t.datetime "created_at",                         :null => false
    t.datetime "updated_at",                         :null => false
    t.datetime "last_login"
  end

  create_table "memberships", :force => true do |t|
    t.integer  "member_id"
    t.integer  "group_id"
    t.datetime "from_date"
    t.datetime "to_date"
    t.boolean  "accepted",   :default => false
    t.boolean  "deleted",    :default => false
    t.datetime "created_at",                    :null => false
    t.datetime "updated_at",                    :null => false
  end

  add_index "memberships", ["group_id"], :name => "index_memberships_on_group_id"
  add_index "memberships", ["member_id"], :name => "index_memberships_on_member_id"

  create_table "permissions", :force => true do |t|
    t.boolean  "can_create",  :default => false
    t.boolean  "can_read",    :default => false
    t.boolean  "can_update",  :default => false
    t.boolean  "can_destroy", :default => false
    t.string   "resource"
    t.integer  "post_id"
    t.datetime "created_at",                     :null => false
    t.datetime "updated_at",                     :null => false
  end

  add_index "permissions", ["post_id"], :name => "index_permissions_on_post_id"

  create_table "semesters", :force => true do |t|
    t.string   "semester"
    t.datetime "valuation_date_from"
    t.datetime "valuation_date_to"
    t.float    "min_scholarship_index"
    t.integer  "created_by"
    t.datetime "created_at",            :null => false
    t.datetime "updated_at",            :null => false
  end

  add_index "semesters", ["created_by"], :name => "index_semesters_on_created_by"

  create_table "valuations", :force => true do |t|
    t.integer  "semester_id"
    t.integer  "member_id"
    t.float    "scholarship_index"
    t.boolean  "community",         :default => false
    t.boolean  "professional",      :default => false
    t.datetime "created_at",                           :null => false
    t.datetime "updated_at",                           :null => false
  end

  add_index "valuations", ["member_id"], :name => "index_valuations_on_member_id"
  add_index "valuations", ["semester_id"], :name => "index_valuations_on_semester_id"

end
