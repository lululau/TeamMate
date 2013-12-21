class Wiki < ActiveRecord::Base
  belongs_to :parent, :class_name => 'Wiki'
  has_many :children, :class_name => 'Wiki', :foreign_key => 'parent_id'
  belongs_to :project
  belongs_to :author, :class_name => 'User'
  has_and_belongs_to_many :contributors, :class_name => :User, :join_table => 'contributors_wikis'

  validates :author, :presence => true
end
