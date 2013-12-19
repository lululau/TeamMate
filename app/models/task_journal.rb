class TaskJournal < ActiveRecord::Base
  belongs_to :task
  belongs_to :operator, :class_name => 'User'

  validates :time_entry_hours, :presence => true
  validates :time_entry_hours, :numericality => {:only_integer => true}, :allow_blank => true
  validates :new_done_ratio, :presence => true
  validates :new_done_ratio, :numericality => {:only_integer => true, :less_than_or_equal_to => 100}, :allow_blank => true
end
