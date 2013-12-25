class Task < ActiveRecord::Base

  module Category
    BUG_FIXING = :bug_fixing
    NEW_FEATURE = :new_feature
    SUPPORT = :support
    OPTIONS = [BUG_FIXING, NEW_FEATURE, SUPPORT]
  end

  belongs_to :assigned_to_user, :class_name => 'User'
  belongs_to :parent, :class_name => 'Task'
  has_many :children, :class_name => 'Task', :foreign_key => 'parent_id'
  belongs_to :project
  has_and_belongs_to_many :watchers, :class_name => 'User', :join_table => 'tasks_watchers'
  has_many :task_journals

  validates :category, :presence => true
  validates :subject, :presence => true, :length => {:maximum => 200}
  validates :assigned_to_user, :presence => true

  validate :check_parent, :on => :update

  private

  def check_parent
    if parent_id == id
      errors.add :parent, '不能设置为自身'
    end
  end

end
