class AddRatioToTasks < ActiveRecord::Migration
  def change
    add_column :tasks, :ratio, :integer, :default => 0
  end
end
