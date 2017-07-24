class AddTranslationTables < ActiveRecord::Migration[4.2]
  def change
    create_table "offer_translations", force: true do |t|
      t.integer  "offer_id",                            null: false
      t.string   "locale",                              null: false
      t.string   "source",                 default: "", null: false
      t.datetime "created_at"
      t.datetime "updated_at"
      t.string   "name",        limit: 80, default: "", null: false
      t.text     "description",            default: "", null: false
      t.text     "next_steps"
      t.text     "opening_specification"
    end

    add_index "offer_translations", ["locale"], name: "index_offer_translations_on_locale"
    add_index "offer_translations", ["offer_id"], name: "index_offer_translations_on_offer_id"

    create_table "organization_translations", force: true do |t|
      t.integer  "organization_id",              null: false
      t.string   "locale",                       null: false
      t.string   "source",          default: "", null: false
      t.datetime "created_at"
      t.datetime "updated_at"
      t.text     "description",     default: "", null: false
    end

    add_index "organization_translations", ["locale"], name: "index_organization_translations_on_locale"
    add_index "organization_translations", ["organization_id"], name: "index_organization_translations_on_organization_id"

    create_table "category_translations", force: true do |t|
      t.integer  "category_id",                  null: false
      t.string   "locale",                       null: false
      t.string   "source",          default: "", null: false
      t.datetime "created_at"
      t.datetime "updated_at"
      t.string   "name",            default: "", null: false
    end

    add_index "category_translations", ["locale"], name: "index_category_translations_on_locale"
    add_index "category_translations", ["category_id"], name: "index_category_translations_on_category_id"
  end
end
