class Task < ActiveRecord::Base
  belongs_to :assigned_to_user, :class_name => 'User'
  belongs_to :parent, :class_name => 'Task'
  has_many :children, :class_name => 'Task', :foreign_key => 'parent_id'
  belongs_to :project
  has_and_belongs_to_many :watchers
  has_many :task_journals
end