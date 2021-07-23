class Cleanup < ApplicationRecord

  belongs_to :user, optional: true

  # validate :trash_was_picked_up
  ############### 20201206 - not sure if we need to geocode since we're just saving the lat/lng, I think that means we've basically already done it
  geocoded_by :latLng

  # after_validation :geocode, if: -> (obj) { (obj.lat.present? and obj.lat_changed?) or (obj.lng.present? and obj.lng_changed?) }

  def latLng
    [self.latitude, self.longitude]
  end

  def age
    today = Date.today
    if created_at < today - 45.days
      return 'red'
    elsif created_at >= (today - 45.days) && created_at < (today - 30.days)
      return 'orange'
    elsif created_at >= (today - 30.days) && created_at < (today - 15.days)
      return 'yellow'
    else
      return 'green'
    end
  end


  def as_json(options = {})
    return {
      user: user ? user.username : nil,
      created_at: created_at.to_date,
      latitude: latitude,
      longitude: longitude,
      age: age,
      small_bags: small_bags,
      buckets: buckets,
      medium_bags: medium_bags,
      large_bags: large_bags,
      participants: participants
    }
  end

  def to_json(*options)
    as_json(*options).to_json(*options)
  end


  private

    def trash_was_picked_up
      if small_bags > 0 || buckets > 0 || medium_bags > 0 || large_bags > 0
        true
      else
        errors.add(:small_bags, "If you didn't pick up any trash, you're not detrashing!")
      end
    end
end
