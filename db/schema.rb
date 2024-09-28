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

ActiveRecord::Schema[7.2].define(version: 2024_09_28_130403) do
  # These are extensions that must be enabled in order to support this database
  enable_extension "plpgsql"

  create_table "weather_forecasts", force: :cascade do |t|
    t.string "search_keyword"
    t.jsonb "response"
    t.integer "ttl"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.string "hashed_coordinates"
    t.index ["hashed_coordinates"], name: "index_weather_forecasts_on_hashed_coordinates"
    t.index ["search_keyword"], name: "index_weather_forecasts_on_search_keyword"
  end
end
