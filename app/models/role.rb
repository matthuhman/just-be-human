class Role < ApplicationRecord

  belongs_to :problem
  belongs_to :user

  ## role level id 1 = ADMIN
  ## role level id 2 = MODERATOR
  ## role level id 3 = PARTICIPANT

  
end
