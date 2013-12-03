class TaskJournal < ActiveRecord::Base
  belongs_to :task
  belongs_to :operator, :class_name => 'User', :foreign_key => 'operator_id'
end
