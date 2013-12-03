class User < ActiveRecord::Base
  has_and_belongs_to_many :managed_projects, :class_name => 'Project', :join_table => 'managers_projects'
  has_and_belongs_to_many :involved_projects, :class_name => 'Project', :join_table => 'members_projects'
  has_many :tasks, :foreign_key => 'assigned_to_user_id'
  has_and_belongs_to_many :watching_tasks, :class_name => 'Task', :join_table => 'tasks_watchers'
  has_many :wikis, :foreign_key => 'author_id'
  has_and_belongs_to_many :contributed_wikis, :class_name => 'Wiki', :join_table => 'contributors_wikis'
  has_many :task_activities, :class_name => 'TaskJournal', :foreign_key => 'operator_id'
end
