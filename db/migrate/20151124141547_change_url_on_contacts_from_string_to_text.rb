class ChangeUrlOnContactsFromStringToText < ActiveRecord::Migration
  def up
    change_column :contacts, :url, :string, limit: 1000
  end

  def down
    change_column :contacts, :url, :string
  end
end
