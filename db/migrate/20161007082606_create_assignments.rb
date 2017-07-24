class CreateAssignments < ActiveRecord::Migration[4.2]
  def change
    create_table :assignments do |t|
      t.integer 'assignable_id', null: false
      t.string 'assignable_type', limit: 32, null: false
      t.string 'assignable_field_type', default: "", limit: 64, null: false

      t.integer 'creator_id', null: true
      t.integer 'creator_team_id', null: true
      t.integer 'reciever_id', null: true
      t.integer 'reciever_team_id', null: true

      t.string 'message', null: true, limit: 1000
      t.integer 'parent_id', null: true
      t.string 'aasm_state', limit: 32, default: "open", null: false

      t.timestamps null: false
    end

    add_index :assignments, [:assignable_id, :assignable_type]
    add_index :assignments, [:creator_id]
    add_index :assignments, [:reciever_id]
    add_index :assignments, [:creator_team_id]
    add_index :assignments, [:reciever_team_id]
    add_index :assignments, [:parent_id]
    add_index :assignments, [:aasm_state]
  end
end
