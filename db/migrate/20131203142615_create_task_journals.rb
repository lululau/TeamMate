class CreateTaskJournals < ActiveRecord::Migration
  def change
    create_table :task_journals do |t|
      t.integer :time_entry_hours
      t.integer :old_done_ratio
      t.integer :new_done_ratio
      t.references :task, index: true
      t.references :operator, index: true

      t.timestamps
    end
  end
end
