class Project < ActiveRecord::Base
  has_and_belongs_to_many :managers, :class_name => 'User', :join_table => 'managers_projects'
  has_and_belongs_to_many :members, :class_name => 'User', :join_table => 'members_projects'
  has_many :wikis
  has_many :tasks

  validates :name, :presence => true, :length => {:maximum => 200}
  validates :managers, :presence => true

  def self.projects_of(user)
    if user.role == 'admin'
      all
    else
      (user.managed_projects + user.involved_projects).uniq
    end
  end
end
