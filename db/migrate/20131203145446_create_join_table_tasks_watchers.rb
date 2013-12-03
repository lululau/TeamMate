class CreateJoinTableTasksWatchers < ActiveRecord::Migration
  def change
    create_join_table :users, :tasks, :table_name => :tasks_watchers do |t|
      # t.index [:user_id, :task_id]
      # t.index [:task_id, :user_id]
    end
  end
end
