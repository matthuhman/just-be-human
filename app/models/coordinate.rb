class Coordinate < ApplicationRecord

  belongs_to :cleanup


  def latLng
    [self.lat, self.lng]
  end

end
