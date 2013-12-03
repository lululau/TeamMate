class CreateTasks < ActiveRecord::Migration
  def change
    create_table :tasks do |t|
      t.string :category
      t.string :subject
      t.text :description
      t.string :priority
      t.references :assigned_to_user, index: true
      t.references :parent, index: true
      t.date :start_date
      t.date :due_date
      t.boolean :at_risk
      t.string :reason_of_risk
      t.references :project, index: true

      t.timestamps
    end
  end
end
