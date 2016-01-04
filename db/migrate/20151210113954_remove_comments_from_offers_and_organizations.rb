class RemoveCommentsFromOffersAndOrganizations < ActiveRecord::Migration
  def change
    remove_column :offers, :comment, :text
    remove_column :organizations, :comment, :text
  end
end
