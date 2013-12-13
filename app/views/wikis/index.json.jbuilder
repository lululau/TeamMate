json.array!(@wikis) do |wiki|
  json.extract! wiki, :subject, :content, :parent_id, :project_id, :author_id
  json.url wiki_url(wiki, format: :json)
end
