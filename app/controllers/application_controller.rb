class ApplicationController < ActionController::Base
  # Prevent CSRF attacks by raising an exception.
  # For APIs, you may want to use :null_session instead.
  protect_from_forgery with: :exception

  before_action :authenticate_user!

  before_action :authorize

  AUTHORIZE_MAP = {
    "projects" => {
      :default => :all,
      "index" => ['admin', 'manager'],
      "new" => ['admin', 'manager'],
      "create" => ['admin', 'manager'],
      "edit" => ['admin', 'manager'],
      "update" => ['admin', 'manager'],
      "destroy" => ['admin', 'manager'],
      "show" => ['admin', 'manager'],
    },
    "people" => {
      :default => :all,
      "tasks" => :all,
      "activities" => :all,
      "index" => ['admin', 'manager'],
      "new" => ['admin', 'manager'],
      "create" => ['admin', 'manager'],
      "edit" => ['admin', 'manager'],
      "update" => ['admin', 'manager'],
      "destroy" => ['admin', 'manager'],
      "show" => ['admin', 'manager'],
    }
  }

  private

  def authorize
    controller_name = self.controller_name
    action_name = self.action_name
    return unless AUTHORIZE_MAP[controller_name]
    action_name = :default unless AUTHORIZE_MAP[controller_name][action_name]
    roles = AUTHORIZE_MAP[controller_name][action_name]
    return if roles == :all
    role = current_user.role
    return if roles.include? role
    redirect_to root_path, :alert => '访问被拒绝，您可能没有权限或未登录。'
  end
end
