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

ActiveRecord::Schema.define(:version => 20120314234351) do

  create_table "algae_distribution_lookups", :force => true do |t|
    t.string   "name"
    t.integer  "code"
    t.datetime "created_at", :null => false
    t.datetime "updated_at", :null => false
  end

  create_table "animal_lookups", :force => true do |t|
    t.string   "name"
    t.integer  "code"
    t.datetime "created_at", :null => false
    t.datetime "updated_at", :null => false
  end

  create_table "biota_lookups", :force => true do |t|
    t.integer  "code"
    t.string   "name"
    t.datetime "created_at", :null => false
    t.datetime "updated_at", :null => false
  end

  create_table "cloud_lookups", :force => true do |t|
    t.string   "name"
    t.string   "code"
    t.datetime "created_at", :null => false
    t.datetime "updated_at", :null => false
  end

  create_table "clouds", :force => true do |t|
    t.float    "cover"
    t.integer  "height"
    t.integer  "cloud_lookup_id"
    t.integer  "meteorology_id"
    t.string   "cloud_type"
    t.datetime "created_at",      :null => false
    t.datetime "updated_at",      :null => false
  end

  create_table "comments", :force => true do |t|
    t.integer  "observation_id"
    t.integer  "user_id"
    t.text     "data"
    t.datetime "created_at",     :null => false
    t.datetime "updated_at",     :null => false
  end

  create_table "floe_size_lookups", :force => true do |t|
    t.string   "name"
    t.integer  "code"
    t.datetime "created_at", :null => false
    t.datetime "updated_at", :null => false
  end

  create_table "ice_discoloration_lookups", :force => true do |t|
    t.string   "name"
    t.integer  "code"
    t.datetime "created_at", :null => false
    t.datetime "updated_at", :null => false
  end

  create_table "ice_field_lookups", :force => true do |t|
    t.string   "name"
    t.integer  "code"
    t.datetime "created_at", :null => false
    t.datetime "updated_at", :null => false
  end

  create_table "ice_lookups", :force => true do |t|
    t.string   "name"
    t.integer  "code"
    t.datetime "created_at", :null => false
    t.datetime "updated_at", :null => false
  end

  create_table "ice_obs_types", :force => true do |t|
    t.string   "name"
    t.datetime "created_at", :null => false
    t.datetime "updated_at", :null => false
  end

  create_table "ice_observations", :force => true do |t|
    t.integer  "observation_id"
    t.integer  "partial_concentration"
    t.integer  "ice_lookup_id"
    t.integer  "thickness"
    t.integer  "floe_size_lookup_id"
    t.integer  "snow_lookup_id"
    t.integer  "snow_thickness"
    t.integer  "biota_lookup_id"
    t.integer  "sediment_lookup_id"
    t.datetime "created_at",            :null => false
    t.datetime "updated_at",            :null => false
    t.string   "obs_type"
  end

  create_table "ices", :force => true do |t|
    t.integer  "observation_id"
    t.integer  "thin_ice_lookup_id"
    t.integer  "thick_ice_lookup_id"
    t.float    "total_concentration"
    t.integer  "open_water_lookup_id"
    t.datetime "created_at",           :null => false
    t.datetime "updated_at",           :null => false
  end

  create_table "max_depth_lookups", :force => true do |t|
    t.string   "name"
    t.integer  "code"
    t.datetime "created_at", :null => false
    t.datetime "updated_at", :null => false
  end

  create_table "melt_ponds", :force => true do |t|
    t.integer  "ice_observation_id"
    t.integer  "surface_coverage"
    t.integer  "max_depth_lookup_id"
    t.integer  "surface_lookup_id"
    t.integer  "freeboard"
    t.integer  "pattern_lookup_id"
    t.datetime "created_at",          :null => false
    t.datetime "updated_at",          :null => false
  end

  create_table "meteorologies", :force => true do |t|
    t.integer  "observation_id"
    t.integer  "visibility_lookup_id"
    t.integer  "weather_lookup_id"
    t.datetime "created_at",           :null => false
    t.datetime "updated_at",           :null => false
  end

  create_table "observation_users", :force => true do |t|
    t.integer  "observation_id"
    t.integer  "user_id"
    t.boolean  "primary"
    t.datetime "created_at",     :null => false
    t.datetime "updated_at",     :null => false
  end

  create_table "observations", :force => true do |t|
    t.integer  "cruise_id"
    t.datetime "obs_datetime"
    t.string   "latitude"
    t.string   "longitude"
    t.string   "hexcode"
    t.datetime "created_at",          :null => false
    t.datetime "updated_at",          :null => false
    t.text     "comments"
    t.text     "additional_comments"
    t.integer  "primary_observer_id"
  end

  create_table "on_boat_location_lookups", :force => true do |t|
    t.string   "name"
    t.integer  "code"
    t.datetime "created_at", :null => false
    t.datetime "updated_at", :null => false
  end

  create_table "open_water_lookups", :force => true do |t|
    t.string   "name"
    t.integer  "code"
    t.datetime "created_at", :null => false
    t.datetime "updated_at", :null => false
  end

  create_table "pattern_lookups", :force => true do |t|
    t.string   "name"
    t.integer  "code"
    t.datetime "created_at", :null => false
    t.datetime "updated_at", :null => false
  end

  create_table "photos", :force => true do |t|
    t.integer  "observation_id"
    t.integer  "on_boat_location_lookup_id"
    t.string   "name"
    t.datetime "created_at",                 :null => false
    t.datetime "updated_at",                 :null => false
    t.string   "checksum_id"
  end

  create_table "progress_lookups", :force => true do |t|
    t.string   "name"
    t.integer  "code"
    t.datetime "created_at", :null => false
    t.datetime "updated_at", :null => false
  end

  create_table "region_lookups", :force => true do |t|
    t.string   "region"
    t.string   "subregion"
    t.integer  "code"
    t.datetime "created_at", :null => false
    t.datetime "updated_at", :null => false
  end

  create_table "sea_state_lookups", :force => true do |t|
    t.string   "name"
    t.integer  "code"
    t.datetime "created_at", :null => false
    t.datetime "updated_at", :null => false
  end

  create_table "sediment_lookups", :force => true do |t|
    t.string   "name"
    t.integer  "code"
    t.datetime "created_at", :null => false
    t.datetime "updated_at", :null => false
  end

  create_table "snow_lookups", :force => true do |t|
    t.string   "name"
    t.integer  "code"
    t.datetime "created_at", :null => false
    t.datetime "updated_at", :null => false
  end

  create_table "snow_obs_types", :force => true do |t|
    t.string   "name"
    t.integer  "code"
    t.datetime "created_at", :null => false
    t.datetime "updated_at", :null => false
  end

  create_table "surface_lookups", :force => true do |t|
    t.string   "name"
    t.integer  "code"
    t.datetime "created_at", :null => false
    t.datetime "updated_at", :null => false
  end

  create_table "topographies", :force => true do |t|
    t.integer  "topography_lookup_id"
    t.integer  "ice_observation_id"
    t.boolean  "old"
    t.boolean  "consolidated"
    t.boolean  "snow_covered"
    t.float    "concentration"
    t.float    "ridge_height"
    t.datetime "created_at",           :null => false
    t.datetime "updated_at",           :null => false
  end

  create_table "topography_lookups", :force => true do |t|
    t.string   "name"
    t.integer  "code"
    t.datetime "created_at", :null => false
    t.datetime "updated_at", :null => false
  end

  create_table "users", :force => true do |t|
    t.string   "firstname"
    t.string   "lastname"
    t.datetime "created_at", :null => false
    t.datetime "updated_at", :null => false
  end

  create_table "visibility_lookups", :force => true do |t|
    t.string   "name"
    t.integer  "code"
    t.datetime "created_at", :null => false
    t.datetime "updated_at", :null => false
  end

  create_table "weather_lookups", :force => true do |t|
    t.integer  "code"
    t.string   "name"
    t.string   "comment"
    t.datetime "created_at", :null => false
    t.datetime "updated_at", :null => false
  end

end
