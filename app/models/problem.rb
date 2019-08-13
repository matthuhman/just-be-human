class Problem < ApplicationRecord
  belongs_to :user
  has_many :roles, :dependent => :destroy
  has_many :milestones, :dependent => :destroy
  has_many :posts, as: :postable, :dependent => :destroy

  geocoded_by :address
  after_validation :geocode


  def user_has_mod_permissions(user_id)
    if user_id == self.user_id
      return true
    end

    role = Role.find(user_id: user_id, problem_id: self.id)

    if role && role.level <= 2
      return true
    else
      return false
    end
  end


  def coordinates
    return [self.latitude, self.longitude]
  end

end
