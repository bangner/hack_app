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

ActiveRecord::Schema.define(version: 20131029011651) do

  create_table "accounts", force: true do |t|
    t.string   "name"
    t.string   "email"
    t.string   "password_hash"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  create_table "accounts_roles", force: true do |t|
    t.integer "account_id"
    t.integer "role_id"
  end

  create_table "accounts_schools", force: true do |t|
    t.integer "account_id"
    t.integer "school_id"
  end

  create_table "applicant_profiles", force: true do |t|
    t.integer  "account_id"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  create_table "applicant_profiles_questions", force: true do |t|
    t.integer "applicant_profile_id"
    t.integer "question_id"
  end

  create_table "applications", force: true do |t|
    t.integer  "applicant_profile_id"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  create_table "questions", force: true do |t|
    t.string   "name"
    t.text     "label"
    t.string   "filter"
    t.string   "question_type"
    t.text     "extra"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  create_table "questions_school_applications", force: true do |t|
    t.integer "question_id"
    t.integer "school_application_id"
  end

  create_table "roles", force: true do |t|
    t.string   "name"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  create_table "school_applications", force: true do |t|
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  create_table "school_invitations", force: true do |t|
    t.integer  "school_id"
    t.string   "email"
    t.string   "code"
    t.boolean  "is_expired", default: false
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  create_table "school_selections", force: true do |t|
    t.integer  "priority"
    t.integer  "school_id"
    t.integer  "application_id"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  create_table "schools", force: true do |t|
    t.integer  "primary_application_id"
    t.integer  "secondary_application_id"
    t.string   "name"
    t.string   "stripe_customer_id"
    t.datetime "created_at"
    t.datetime "updated_at"
    t.text     "description"
    t.string   "duration"
    t.string   "stack"
    t.string   "website"
    t.string   "email"
    t.string   "twitter"
    t.string   "facebook"
    t.string   "street"
    t.string   "city"
    t.string   "state"
    t.string   "price"
    t.string   "video"
    t.string   "zip"
    t.text     "content"
    t.text     "logo"
  end

end
