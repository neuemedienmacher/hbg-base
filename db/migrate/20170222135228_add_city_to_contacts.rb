class AddCityToContacts < ActiveRecord::Migration[4.2]
  def change
    add_column :contacts, :city, :string, :null => true
  end
end
