class Problem < ApplicationRecord
  belongs_to :user
  has_many :roles, :dependent => :destroy
  has_many :milestones, :dependent => :destroy
  has_many :posts, as: :postable, :dependent => :destroy


  
end
