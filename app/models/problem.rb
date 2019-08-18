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

    role = ProblemRole.find_by(user_id: user_id, problem_id: self.id)

    if role && role.level <= 2
      return true
    else
      return false
    end
  end

  def category_title
    Category.problem_titles[self.category.to_i]
  end

  def subcategory_title
    Category.problem_subcat_titles(self.category.to_i)[self.subcategory.to_i]
  end


  def self.users_are_volunteers(*args)
    args.each do |id|
      # role = ProblemRole.



    end


  end


  def coordinates
    return [self.latitude, self.longitude]
  end

  def as_json(options = { })
    # just in case someone says as_json(nil) and bypasses
    # our default...
    super((options || { }).merge({
      :methods => [:category_title, :subcategory_title]
    }))
  end

end
