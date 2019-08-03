class Problem < ApplicationRecord
  belongs_to :user
  has_many :roles
end
