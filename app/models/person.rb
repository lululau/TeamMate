class Person < ActiveRecord::Base
  module Role
    ADMIN = :admin
    MANAGER = :manager
    NORMAL = :normal
    OPTIONS = [ADMIN, MANAGER, NORMAL]
  end
  self.table_name = 'users'

  validates :name, :presence => true, :length => {:maximum => 200}, :uniqueness => true
  validates :email, :presence => true
  validates :role, :presence => true
  validates :encrypted_password, :presence => true, :length => { :in => 8..200 }
  validates :encrypted_password, :confirmation => true
  #validates :encrypyed_password_confirmation, :presence => true
end
