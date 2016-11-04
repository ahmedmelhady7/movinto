json.extract! movie, :id, :name, :is_featured, :released_at, :average_rating, :created_at, :updated_at
json.url movie_url(movie, format: :json)