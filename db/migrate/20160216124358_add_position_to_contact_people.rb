class AddPositionToContactPeople < ActiveRecord::Migration[4.2]
  def change
    add_column :contact_people, :position, :string
  end
end
