class AddVisibleToContactPersons < ActiveRecord::Migration
  def change
    add_column :contact_people, :visible, :boolean, default: true
  end
end
