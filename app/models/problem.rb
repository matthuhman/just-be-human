class Problem < ApplicationRecord
  belongs_to :user
  has_many :problem_roles, :dependent => :destroy
  has_many :milestones, :dependent => :destroy
  has_many :posts, as: :postable, :dependent => :destroy

  geocoded_by :address
  after_validation :geocode, if: -> (obj) { obj.address.present? and obj.address_changed? }


  def user_is_admin(user_id)
    return user_id == self.user_id
  end


  def user_has_mod_permissions(user_id)
    if user_id == self.user_id
      return true
    end

    role = ProblemRole.find(user_id: user_id, problem_id: self.id)

    if role && role.level <= 2
      return true
    else
      return false
    end
  end


  def self.users_are_volunteers(*args)
    args.each do |id|
      role = ProblemRole.



    end


  end


  def coordinates
    return [self.latitude, self.longitude]
  end

end
