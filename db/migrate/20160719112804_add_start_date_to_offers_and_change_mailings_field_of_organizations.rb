class AddStartDateToOffersAndChangeMailingsFieldOfOrganizations < ActiveRecord::Migration
  def up
    # create new mailings field
    add_column :organizations, :mailings, :string, limit: 255, default: 'disabled', null: false

    # transfer current data (mailings_enabled boolean) to mailings
    Organization.where(mailings_enabled: true).find_each do |orga|
      # every mailings_enabled stays enabled, default is disabled
      orga.update_columns mailings: 'enabled'
    end

    # remove mailings_enabled field
    remove_column :organizations, :mailings_enabled

    # add new optional starts_at field to offers (marks seasonal offers)
    add_column :offers, :starts_at, :date, null: true
  end
  
  def down
    add_column :organizations, :mailings_enabled, :boolean, default: false

    Organization.find_each do |orga|
      orga.update_columns mailings_enabled: orga.mailings == 'enabled'
    end

    remove_column :organizations, :mailings

    # add new optional starts_at field to offers (marks seasonal offers)
    remove_column :offers, :starts_at
  end
end
