class RemoveRoleFromContactPeople < ActiveRecord::Migration[4.2]
  def change
    remove_column :contact_people, :role
  end
end
