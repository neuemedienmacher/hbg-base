class ChangeDivisionNameToAddition < ActiveRecord::Migration[4.2]
  def change
    rename_column :divisions, :name, :addition
    change_column :divisions, :addition, :string, null: true
  end
end
