class Milestone < ApplicationRecord
  
  belongs_to :problem
  has_many :comments, as: :commentable, :dependent => :destroy
  has_many :milestone_roles, :dependent => :destroy
  



end
