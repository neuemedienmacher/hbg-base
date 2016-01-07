class AddNextSteps < ActiveRecord::Migration
  def change
    rename_column :offers, :next_steps, :old_next_steps
    rename_column :offer_translations, :next_steps, :old_next_steps

    create_table 'next_steps', force: true do |t|
      t.string   'text_de', null: false
      t.string   'text_en'
      t.string   'text_ar'
      t.string   'text_fr'
      t.string   'text_pl'
      t.string   'text_tr'
      t.string   'text_ru'
    end

    add_index 'next_steps', ['text_de'], name: 'index_next_steps_on_text_de'

    create_table 'next_steps_offers', force: true do |t|
      t.integer  'next_step_id', null: false
      t.integer  'offer_id',     null: false
    end

    add_index 'next_steps_offers', ['next_step_id'],
              name: 'index_next_steps_offers_on_next_step_id'
    add_index 'next_steps_offers', ['offer_id'],
              name: 'index_organization_translations_on_offer_id'
  end
end
