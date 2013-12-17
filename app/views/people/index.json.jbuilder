json.array!(@people) do |person|
  json.extract! person, :name, :email, :password, :role, :avatar, :locked
  json.url person_url(person, format: :json)
end
