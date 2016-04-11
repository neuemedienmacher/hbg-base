class ChangeTranslationStringLengths < ActiveRecord::Migration
  def change
    change_column :offer_translations, :name, :string, limit: 255
  end
end
