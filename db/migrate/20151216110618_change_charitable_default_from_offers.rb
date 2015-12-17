class ChangeCharitableDefaultFromOffers < ActiveRecord::Migration
  def change
    change_column_default :organizations, :charitable, false
  end
end
