class CreateProjects < ActiveRecord::Migration
  def change
    create_table :projects do |t|
      t.string :name
      t.text :description
      t.boolean :public
      t.integer :root_wiki_id

      t.timestamps
    end
  end
end
