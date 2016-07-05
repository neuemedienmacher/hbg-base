class AddGengoOrder < ActiveRecord::Migration
  def change
    create_table 'gengo_orders' do |t|
      t.integer   'order_id'
      t.string    'expected_slug'
      t.timestamps                  null: false
    end
  end
end
