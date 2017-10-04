class RemoveCommentsFromOffersAndOrganizations < ActiveRecord::Migration[4.2]
  def change
    remove_column :offers, :comment, :text
    remove_column :organizations, :comment, :text
  end
end
