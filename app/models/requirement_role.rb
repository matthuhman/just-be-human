class RequirementRole < ApplicationRecord


  belongs_to :user
  belongs_to :requirement

  after_create :set_opportunity_id



  private
  def set_opportunity_id
    opportunity_id = requirement.opportunity_id
    save
  end


end
