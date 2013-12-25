class UserMailer < ActionMailer::Base
  default :from => 'team_mates@163.com'

  def account_unlocked(user)
    @user = user
    mail :to => @user.email, :subject => '激活账号信息'
  end

  def password_changed(user, password)
    @user = user
    @password = password
    mail :to => @user.email, :subject => '密码变更信息'
  end

  def account_created(user, password)
    @user = user
    @password = password
    mail :to => @user.email, :subject => '创建账号信息'
  end

  def registration_created(user)
    @user = user
    admins_and_managers = User.where :role => [:admin, :manager]
    mail :to => admins_and_managers.map{|u| u.email}, :subject => '注册账号信息'
  end

  def task_changed(task_journal)
    @task_journal = task_journal
    @task = task_journal.task
    users = [@task.assigned_to_user] + @task.watchers
    mail :to => users.map{|u| u.email}, :subject => '任务状态变更信息'
  end

  def task_assigned(task)
    @task = task
    @user = task.assigned_to_user
    mail :to => @user.email, :subject => '任务指派信息'
  end
end
