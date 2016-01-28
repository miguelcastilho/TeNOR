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

ActiveRecord::Schema.define(version: 20150902172401) do

  create_table "breaches", force: :cascade do |t|
    t.integer  "nsi_id_id",             null: false
    t.integer  "vnfi_id"
    t.integer  "nli_id"
    t.integer  "external_parameter_id", null: false
    t.float    "value"
    t.datetime "created_at",            null: false
    t.datetime "updated_at",            null: false
  end

  create_table "parameters", force: :cascade do |t|
    t.string   "parameter_id", null: false
    t.float    "minimum"
    t.float    "maximum"
    t.integer  "sla_id"
    t.datetime "created_at",   null: false
    t.datetime "updated_at",   null: false
  end

  add_index "parameters", ["sla_id"], name: "index_parameters_on_sla_id"

  create_table "slas", force: :cascade do |t|
    t.string   "nsi_id",     null: false
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
  end

  create_table "violations", force: :cascade do |t|
    t.integer  "parameter_id"
    t.integer  "breaches_count"
    t.integer  "interval"
    t.datetime "created_at",     null: false
    t.datetime "updated_at",     null: false
  end

  add_index "violations", ["parameter_id"], name: "index_violations_on_parameter_id"

end
