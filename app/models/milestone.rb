class Milestone < ApplicationRecord
  
  belongs_to :problem
  has_many :posts, as: :postable, :dependent => :destroy
  has_many :milestone_roles, :dependent => :destroy
  


  def user_has_mod_permissions(user_id)
    if user_id == self.user_id
      return true
    end

    role = MilestoneRole.find(user_id: user_id, milestone_id: self.id)

    if role && role.level <= 2
      return true
    else
      role = Role.find(user_id: user_id, problem_id: self.problem_id)
      if role && role.level <= 2
        return true
      else
        return false
      end
    end
  end



end
