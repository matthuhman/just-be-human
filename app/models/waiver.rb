class Waiver < ApplicationRecord

  belongs_to :user
  belongs_to :parent_waiver, foreign_key: :parent_waiver_id, optional: true
  has_many :opportunities, through: :opportunity_waivers
  belongs_to :signatures, optional: true
  has_one_attached :waiver_file


  validates_presence_of :waiver_file

end
