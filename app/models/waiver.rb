class Waiver < ApplicationRecord

  belongs_to :user
  belongs_to :parent_waiver, foreign_key: :parent_waiver_id
  has_many :opportunities, through: :opportunity_waivers
  has_one_attached :waiver_file
  geocoded_by :location
  after_validation :geocode, if: -> (obj) { obj.location.present? and obj.location_changed? }

end
