class CreateJoinTableManagersProjects < ActiveRecord::Migration
  def change
    create_join_table :users, :projects, :table_name => :managers_projects do |t|
      # t.index [:user_id, :project_id]
      # t.index [:project_id, :user_id]
    end
  end
end
