class CreateTopic < ActiveRecord::Migration
  def change
    create_table :topics do |t|
      t.string :name
    end

    create_table :topics_organizations do |t|
      t.integer :topic_id
      t.integer :organization_id
    end

    add_index :topics_organizations, [:organization_id],
              name: 'index_topics_organizations_on_organization_id',
              using: :btree
    add_index :topics_organizations, [:topic_id],
              name: 'index_topics_organizations_on_topic_id', using: :btree
  end
end
