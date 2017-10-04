class AddCodeWordToOffers < ActiveRecord::Migration[4.2]
  def change
    add_column :offers, :code_word, :string, limit: 140
  end
end
