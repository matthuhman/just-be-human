json.extract! opportunity, :title, :description, :location, :start_time, :end_time, :user_id
json.url opportunity_url(opportunity, format: :json)
