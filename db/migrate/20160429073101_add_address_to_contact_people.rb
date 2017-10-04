class AddAddressToContactPeople < ActiveRecord::Migration[4.2]
  def change
    add_column :contact_people, :street, :string, limit: 255
    add_column :contact_people, :zip_and_city, :string, limit: 255
  end
end
