class AddCommentToOffer < ActiveRecord::Migration
  def change
    add_column :offers, :comment, :string
  end
end
