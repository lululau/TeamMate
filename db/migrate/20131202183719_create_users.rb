class CreateUsers < ActiveRecord::Migration
  def change
    create_table :users do |t|
      t.string :name
      t.string :email
      t.string :password
      t.string :role
      t.string :remember_me_token
      t.integer :avatar
      t.boolean :locked
      t.datetime :last_signin_time

      t.timestamps
    end
  end
end
