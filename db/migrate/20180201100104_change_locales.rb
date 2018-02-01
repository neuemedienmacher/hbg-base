class ChangeLocales < ActiveRecord::Migration[5.1]
  def change
    remove_column :next_steps, :text_ru
    rename_column :next_steps, :text_pl, :text_ps

    remove_column :tags, :name_ru
    rename_column :tags, :name_pl, :name_ps

    remove_column :target_audience_filters_offers, :stamp_ru
    rename_column :target_audience_filters_offers, :stamp_pl, :stamp_ps
  end
end
