class AddCommentToTimeAllocations < ActiveRecord::Migration[4.2]
  def change
    add_column :time_allocations, :actual_wa_comment, :string
  end
end
