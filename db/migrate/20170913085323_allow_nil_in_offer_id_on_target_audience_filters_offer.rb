class AllowNilInOfferIdOnTargetAudienceFiltersOffer < ActiveRecord::Migration[4.2]
  def up
    change_column :target_audience_filters_offers, :offer_id, :integer,
                  null: true
  end

  def down
    change_column :target_audience_filters_offers, :offer_id, :integer,
                  null: false
  end
end
