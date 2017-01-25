class ChangeDivisions < ActiveRecord::Migration
  def up
    change_column :divisions, :organization_id, :integer, null: true
  end

  def down
    change_column :divisions, :organization_id, :integer, null: false
  end
end
