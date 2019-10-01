class OpportunityRole < ApplicationRecord

  belongs_to :opportunity
  belongs_to :user

  ## role level id 1 = LEADER
  ## role level id 2 = SUPERVISOR
  ## role level id 3 = VOLUNTEER
  ## role level id 4 = FOLLOWER




end
