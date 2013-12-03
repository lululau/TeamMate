class TaskJournal < ActiveRecord::Base
  belongs_to :task
  belongs_to :operator, :class_name => 'User'
end
