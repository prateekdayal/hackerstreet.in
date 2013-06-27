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

ActiveRecord::Schema.define(:version => 20130627053507) do

  create_table "comments", :force => true do |t|
    t.text     "body"
    t.integer  "commentable_id"
    t.integer  "comment_id"
    t.string   "commentable_type"
    t.datetime "created_at",                            :null => false
    t.datetime "updated_at",                            :null => false
    t.integer  "story_id"
    t.string   "ancestry"
    t.integer  "score",            :default => 1
    t.integer  "user_id"
    t.float    "total"
    t.string   "kill_action",      :default => "kill"
    t.string   "blast_action",     :default => "blast"
    t.boolean  "dead",             :default => false
  end

  add_index "comments", ["ancestry"], :name => "index_comments_on_ancestry"
  add_index "comments", ["story_id"], :name => "index_comments_on_story_id"

  create_table "stories", :force => true do |t|
    t.string   "title"
    t.string   "url"
    t.datetime "created_at",                        :null => false
    t.datetime "updated_at",                        :null => false
    t.integer  "score",        :default => 1
    t.integer  "user_id"
    t.float    "total"
    t.string   "text"
    t.string   "kill_action",  :default => "kill"
    t.string   "blast_action", :default => "blast"
    t.string   "nuke_action",  :default => "nuke"
    t.boolean  "dead",         :default => false
  end

  create_table "users", :force => true do |t|
    t.string   "name"
    t.datetime "created_at",                                   :null => false
    t.datetime "updated_at",                                   :null => false
    t.boolean  "admin",                  :default => false
    t.string   "email",                  :default => "",       :null => false
    t.string   "encrypted_password",     :default => "",       :null => false
    t.string   "reset_password_token"
    t.datetime "reset_password_sent_at"
    t.datetime "remember_created_at"
    t.integer  "sign_in_count",          :default => 0
    t.datetime "current_sign_in_at"
    t.datetime "last_sign_in_at"
    t.string   "current_sign_in_ip"
    t.string   "last_sign_in_ip"
    t.string   "password_salt"
    t.integer  "karma",                  :default => 1
    t.string   "role",                   :default => "author"
    t.integer  "roles_mask"
    t.boolean  "ignore",                 :default => false
    t.string   "twitter"
    t.string   "facebook"
    t.string   "github"
    t.string   "linkedin"
  end

  add_index "users", ["email"], :name => "index_users_on_email", :unique => true
  add_index "users", ["reset_password_token"], :name => "index_users_on_reset_password_token", :unique => true

  create_table "votes", :force => true do |t|
    t.boolean  "vote",          :default => false, :null => false
    t.integer  "voteable_id",                      :null => false
    t.string   "voteable_type",                    :null => false
    t.integer  "voter_id"
    t.string   "voter_type"
    t.datetime "created_at",                       :null => false
    t.datetime "updated_at",                       :null => false
  end

  add_index "votes", ["voteable_id", "voteable_type"], :name => "index_votes_on_voteable_id_and_voteable_type"
  add_index "votes", ["voter_id", "voter_type", "voteable_id", "voteable_type"], :name => "fk_one_vote_per_user_per_entity", :unique => true
  add_index "votes", ["voter_id", "voter_type"], :name => "index_votes_on_voter_id_and_voter_type"

end
