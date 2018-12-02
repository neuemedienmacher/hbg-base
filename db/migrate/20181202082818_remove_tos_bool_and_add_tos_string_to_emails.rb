class RemoveTosBoolAndAddTosStringToEmails < ActiveRecord::Migration[5.1]
  def change
    remove_column :emails, :tos_accepted
    add_column :emails, :tos, :string, default: 'uninformed', null: false
  end
end
