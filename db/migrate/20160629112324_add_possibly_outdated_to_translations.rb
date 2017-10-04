class AddPossiblyOutdatedToTranslations < ActiveRecord::Migration[4.2]
  def change
    add_column :offer_translations, :possibly_outdated, :boolean,
               default: false
    add_column :organization_translations, :possibly_outdated, :boolean,
               default: false
  end
end
