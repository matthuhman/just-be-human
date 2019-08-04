class Problem < ApplicationRecord
  belongs_to :user
  has_many :roles
  has_many :comments, as: :commentable


  
end
