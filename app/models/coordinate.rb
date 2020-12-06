class Coordinate < ApplicationRecord

  belongs_to :opportunity


  def latLng
    [self.lat, self.lng]
  end

end
