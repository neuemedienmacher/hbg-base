class AddUnreachableFlagToWebsites < ActiveRecord::Migration[4.2]
  def change
    add_column :websites, :unreachable, :boolean, default: false
  end
end
