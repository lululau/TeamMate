class Wiki < ActiveRecord::Base
  belongs_to :parent, :class_name => 'Wiki'
  has_many :children, :class_name => 'Wiki', :foreign_key => 'parent_id'
  belongs_to :project
  belongs_to :author, :class_name => 'User'
  has_and_belongs_to_many :contributors, :class_name => :User, :join_table => 'contributors_wikis'

  validates :author, :presence => true
  validate :check_parent, :on => :update

  private

  def check_parent
    if parent_id == id
      errors.add :parent, '不能设置为自身'
    end
  end
end
