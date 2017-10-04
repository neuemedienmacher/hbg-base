class RenameRecieverToReceiver < ActiveRecord::Migration[4.2]
  def change
    rename_column :assignments, :reciever_id, :receiver_id
    rename_column :assignments, :reciever_team_id, :receiver_team_id
  end
end
