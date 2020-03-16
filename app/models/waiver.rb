class Waiver < ApplicationRecord

  belongs_to :user
  belongs_to :parent_waiver, foreign_key: :parent_waiver_id, optional: true
  has_many :opportunities, through: :opportunity_waivers
  belongs_to :signatures, dependent: :destroy
  has_one_attached :waiver_file

end
