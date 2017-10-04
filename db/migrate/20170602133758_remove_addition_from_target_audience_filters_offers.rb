class RemoveAdditionFromTargetAudienceFiltersOffers < ActiveRecord::Migration[4.2]
  def change
    remove_column :target_audience_filters_offers, :addition
  end
end
