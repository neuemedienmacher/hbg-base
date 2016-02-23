class AddPositionToContactPeople < ActiveRecord::Migration
  def change
    add_column :contact_people, :position, :string
  end
end
