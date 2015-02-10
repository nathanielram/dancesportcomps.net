json.array!(@competitions) do |competition|
  json.extract! competition, :id, :name, :start, :end, :comp_association, :location
  json.url competition_url(competition, format: :json)
end
