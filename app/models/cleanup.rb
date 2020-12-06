class Cleanup < ApplicationRecord

  belongs_to :user, optional: true
  has_many :coordinates

  reverse_geocoded_by :lat, :lng
  after_validation :reverse_geocode, if: -> (obj) { (obj.lat.present? and obj.lat_changed?) or (obj.lng.present? and obj.lng_changed?) }

  def latLng
    [self.lat, self.lng]
  end

  def age
    today = Date.today
    if created_at < today - 14.days
      return 'red'
    elsif created_at >= (today - 14.days) && created_at < (today - 7.days)
      return 'orange'
    else
      return 'green'
    end
  end
end
