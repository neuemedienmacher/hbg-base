class AddInteralMailToContact < ActiveRecord::Migration
  def change
    add_column :contacts, :internal_mail, :boolean, default: false
  end
end
