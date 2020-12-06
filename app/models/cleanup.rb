class Cleanup < ApplicationRecord

  belongs_to :user, optional: true
  has_many :coordinates


  ############### 20201206 - not sure if we need to geocode since we're just saving the lat/lng, I think that means we've basically already done it
  geocoded_by :latLng
  # after_validation :geocode, if: -> (obj) { (obj.lat.present? and obj.lat_changed?) or (obj.lng.present? and obj.lng_changed?) }

  def latLng
    [self.lat, self.lng]
  end

  def age
    today = Date.today
    if created_at < today - 56.days
      return 'red'
    elsif created_at >= (today - 56.days) && created_at < (today - 28.days)
      return 'orange'
    elsif created_at >= (today - 28.days) && created_at < (today - 14.days)
      return 'yellow'
    else
      return 'green'
    end
  end
end
