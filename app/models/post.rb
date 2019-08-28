class Post < ApplicationRecord

  belongs_to :postable, polymorphic: true
  has_many :comments
  # has_rich_text :content


  def user_has_permissions(user_id)
    if (self.postable_type == "Requirement")
      return Requirement.find(self.postable_id).user_has_mod_permissions(user_id)
    else
      return Problem.find(self.postable_id).user_has_mod_permissions(user_id)
    end
  end



  def user_can_comment(user_id)
    if (self.postable_type == 'Problem')
      role = ProblemRole.find_by(user_id: user_id, problem_id: self.postable_id)
      if role
        return true
      end
    else
      problem_id = Requirement.find(self.postable_id).problem_id
      role = ProblemRole.find_by(user_id: user_id, problem_id: problem_id)
      if role
        return true;
      end
    end

    return false
  end
end
