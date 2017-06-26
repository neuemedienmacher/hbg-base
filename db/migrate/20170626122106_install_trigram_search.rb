class InstallTrigramSearch < ActiveRecord::Migration
  def up
    # testing environment does not use postgresql
    unless Rails.env.test?
      execute "CREATE EXTENSION pg_trgm;"
    end
  end

  def down
    unless Rails.env.test?
      execute "DROP EXTENSION pg_trgm;"
    end
  end
end
