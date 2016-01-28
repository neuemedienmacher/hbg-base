class AddCodeWordToOffers < ActiveRecord::Migration
  def change
    add_column :offers, :code_word, :string, limit: 140
  end
end
