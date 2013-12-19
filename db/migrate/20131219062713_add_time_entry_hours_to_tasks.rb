class AddTimeEntryHoursToTasks < ActiveRecord::Migration
  def change
    add_column :tasks, :time_entry_hours, :integer, :default => 0
  end
end
