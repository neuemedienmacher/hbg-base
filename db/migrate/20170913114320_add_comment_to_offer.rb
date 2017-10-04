class AddCommentToOffer < ActiveRecord::Migration[4.2]
  def change
    add_column :offers, :comment, :string
  end
end
