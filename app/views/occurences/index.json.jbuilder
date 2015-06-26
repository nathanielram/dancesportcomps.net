json.array!(@occurences) do |occurence|
  json.extract! occurence, :id
  json.url occurence_url(occurence, format: :json)
end
