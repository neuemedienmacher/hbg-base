class ChangeNameLengthOfferTranslations < ActiveRecord::Migration
  def up
    change_column :offer_translations, :name, :string, limit: 120, null: false
  end

  def down
    change_column :offer_translations, :name, :string, limit: 80, null: false
  end
end
