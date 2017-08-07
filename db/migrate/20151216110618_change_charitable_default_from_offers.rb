class ChangeCharitableDefaultFromOffers < ActiveRecord::Migration[4.2]
  def change
    change_column_default :organizations, :charitable, false
  end
end
