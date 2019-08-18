class Milestone < ApplicationRecord
  
  belongs_to :problem
  has_many :posts, as: :postable, :dependent => :destroy
  has_many :milestone_roles, :dependent => :destroy
  


  def user_has_mod_permissions(u_id)
    if u_id == self.user_id
      return true
    end

    level = Role.milestone_role_level(u_id, self.id)

    if level < 2
      return true
    else
      if Role.problem_role_level(u_id, self.problem_id) <= 2
        return true
      else
        return false
      end
    end
  end


end
