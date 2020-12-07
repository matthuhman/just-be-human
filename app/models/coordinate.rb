class Coordinate < ApplicationRecord

  belongs_to :cleanup


  def latLng
    [self.lat, self.lng]
  end


  def as_json(options = {})
    [lat, lng]
  end

  def to_json(*options)
    as_json(*options).to_json(*options)
  end

end
