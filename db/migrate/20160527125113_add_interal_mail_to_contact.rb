class AddInteralMailToContact < ActiveRecord::Migration[4.2]
  def change
    add_column :contacts, :internal_mail, :boolean, default: false
  end
end
