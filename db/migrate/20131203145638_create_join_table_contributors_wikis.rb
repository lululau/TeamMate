class CreateJoinTableContributorsWikis < ActiveRecord::Migration
  def change
    create_join_table :users, :wikis, :table_name => :contributors_wikis do |t|
      # t.index [:user_id, :wiki_id]
      # t.index [:wiki_id, :user_id]
    end
  end
end
