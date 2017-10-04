class ChangeTranslationStringLengths < ActiveRecord::Migration[4.2]
  def change
    change_column :offer_translations, :name, :string, limit: 255
  end
end
