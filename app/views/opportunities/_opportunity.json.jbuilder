json.extract! opportunity, :id, :title, :description, :location, :target_completion_date, :user_id, :created_at, :updated_at
json.url opportunity_url(opportunity, format: :json)
