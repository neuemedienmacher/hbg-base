class AddTranslationToContactPeopleResponsibility < ActiveRecord::Migration
  def change

    create_table "contact_people_translations", force: true do |t|
      t.integer  "contact_people_id",              null: false
      t.string   "locale",                       null: false
      t.string   "source",          default: "", null: false
      t.datetime "created_at"
      t.datetime "updated_at"
      t.text     "responsibility",     default: "", null: false
    end

    add_index "contact_people_translations", ["locale"], name: "index_contact_people_translations_on_locale"
    add_index "contact_people_translations", ["contact_people_id"], name: "index_contact_people_translations_on_contact_people_id"

  end
end
