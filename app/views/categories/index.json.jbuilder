json.array!(@categories) do |category|
  json.extract! category, :id, :title, :short_description, :description
  json.url category_url(category, format: :json)
end
