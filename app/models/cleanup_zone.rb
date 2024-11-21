class CleanupZone < ApplicationRecord

  belongs_to :user, optional: true
  has_many :coordinates, dependent: :destroy



  geocoded_by :latLng




  private

  def latLng
    [self.latitude, self.longitude]
  end
end
