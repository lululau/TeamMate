class CreateWikis < ActiveRecord::Migration
  def change
    create_table :wikis do |t|
      t.string :subject
      t.text :content
      t.references :parent, index: true
      t.references :project, index: true
      t.references :author, index: true

      t.timestamps
    end
  end
end
