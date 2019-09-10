require 'yaml'
require 'obscenity/active_model'

class Requirement < ApplicationRecord

  belongs_to :problem
  has_many :posts, as: :postable, :dependent => :destroy
  has_many :requirement_roles, :dependent => :destroy


  validates_presence_of :title, message: 'must be entered.'
  validates_presence_of :description, message: 'must be entered.'

  validates :title, obscenity: true
  validates :current_status, obscenity: true
  validates :description, obscenity: { sanitize: true, replacement: '[censored]' }

  validate :completion_date_limit, :field_length



  def pct_remaining_display
    self.pct_work_remaining.round.to_s << "%"
  end


  def user_has_mod_permissions(u_id)
    if u_id == self.user_id
      return true
    end

    level = Role.requirement_role_level(u_id, self.id)

    if level < 2
      true
    else
      if Role.problem_role_level(u_id, self.problem_id) <= 2
        true
      else
        false
      end
    end
  end

  def category_title
    Category.req_titles[self.category.to_i]
  end

  def subcategory_title
    Category.req_subcat_titles(self.category.to_i)[self.subcategory.to_i]
  end



  ## BEGIN PRIVATE METHODS
  private
  def field_length
    if title.size > 60
      errors.add(:title, "must be less than 60 characters")
    end
    if current_status.size > 60
      errors.add(:current_status, "must be less than 60 characters")
    end
  end

  def completion_date_limit
    if target_completion_date > problem.target_completion_date
      errors.add(:target_completion_date, "cannot be after the Problem's target completion date.")
    end
  end

end
