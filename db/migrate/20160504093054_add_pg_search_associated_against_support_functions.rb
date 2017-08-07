class AddPgSearchAssociatedAgainstSupportFunctions < ActiveRecord::Migration[4.2]
  def self.up
    return if ActiveRecord::Base.connection.adapter_name != 'PostgreSQL'
    say_with_time("Adding support functions for pg_search :associated_against") do
      if ActiveRecord::Base.connection.send(:postgresql_version) < 80400
        execute <<-'SQL'
CREATE AGGREGATE array_agg(anyelement) (
  SFUNC=array_append,
  STYPE=anyarray,
  INITCOND='{}'
)
        SQL
      end
    end
  end

  def self.down
    return if ActiveRecord::Base.connection.adapter_name != 'PostgreSQL'
    say_with_time("Dropping support functions for pg_search :associated_against") do
      if ActiveRecord::Base.connection.send(:postgresql_version) < 80400
        execute <<-SQL
DROP AGGREGATE array_agg(anyelement);
        SQL
      end
    end
  end
end
