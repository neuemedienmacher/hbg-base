class ChangeUrlOnContactsFromStringToText < ActiveRecord::Migration[4.2]
  def up
    change_column :contacts, :url, :string, limit: 1000
  end

  def down
    change_column :contacts, :url, :string
  end
end
