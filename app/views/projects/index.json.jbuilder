json.array!(@projects) do |project|
  json.extract! project, :name, :description, :public
  json.url project_url(project, format: :json)
end
