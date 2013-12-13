json.array!(@tasks) do |task|
  json.extract! task, :category, :subject, :description, :priority, :start_date, :due_date, :at_risk, :assigned_to_user_id, :parent_id, :project_id
  json.url task_url(task, format: :json)
end
