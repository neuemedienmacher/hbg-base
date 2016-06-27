class AddTimestampstoNextSteps < ActiveRecord::Migration
  def up
      change_table :next_steps do |t|
          t.timestamps
      end
  end
  def down
      remove_column :next_steps, :created_at
      remove_column :next_steps, :updated_at
  end
end
