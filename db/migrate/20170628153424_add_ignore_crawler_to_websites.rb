class AddIgnoreCrawlerToWebsites < ActiveRecord::Migration[4.2]
  def change
    add_column :websites, :ignored_by_crawler, :boolean, default: false
  end
end
