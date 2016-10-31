class AddCommentToTimeAllocations < ActiveRecord::Migration
  def change
    add_column :time_allocations, :actual_wa_comment, :string
  end
end
