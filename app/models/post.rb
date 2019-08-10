class Post < ApplicationRecord

  belongs_to :postable, polymorphic: true
  has_many :comments



  def is_user_admin(user_id)
    parent_id = self.postable_id
    if (self.postable_type == "Milestone")
      ms_role = MilestoneRole.find_by(user_id: user_id, milestone_id: parent_id)
      if ms_role && ms_role.level <= 2
        binding.pry
        return true
      end
    else
      prob_role = Role.find_by(user_id: user_id, problem_id: parent_id)
      if prob_role && prob_role.level <= 2
        binding.pry
        return true
      end
    end
    binding.pry
    return false
  end

end
