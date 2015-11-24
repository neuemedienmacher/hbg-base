class ChangeUrlOnContactsFromStringToText < ActiveRecord::Migration
  def up
    change_column :contacts, :url, :text, :limit => 1000
  end

  def down
    change_column :contacts, :url, :string
  end
end
