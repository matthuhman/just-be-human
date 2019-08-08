class Problem < ApplicationRecord
  belongs_to :user
  has_many :roles, :dependent => :destroy
  has_many :milestones, :dependent => :destroy
  has_many :comments, as: :commentable, :dependent => :destroy


  
end
