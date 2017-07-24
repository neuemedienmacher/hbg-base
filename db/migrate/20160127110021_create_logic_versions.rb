class CreateLogicVersions < ActiveRecord::Migration[4.2]
  def change
    create_table :logic_versions do |t|
      t.integer :version
      t.string :name
    end

    add_column :offers, :logic_version_id, :integer
    add_index :offers, [:logic_version_id]
  end
end
