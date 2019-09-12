require 'yaml'
require 'obscenity/active_model'

class Requirement < ApplicationRecord

  belongs_to :opportunity
  has_many :posts, as: :postable, :dependent => :destroy
  has_many :requirement_roles, :dependent => :destroy


  validates_presence_of :title, message: 'must be entered.'
  validates_presence_of :description, message: 'must be entered.'

  validates :title, obscenity: true
  validates :status, obscenity: true
  validates :description, obscenity: { sanitize: true, replacement: '[censored]' }

  validate :completion_date_limit, :field_length



  def pct_done_display
    self.pct_done.round.to_s << "%"
  end

  def overdue?
    target_completion_date < Date.today
  end

  def leader
    RequirementRole.find_by(requirement_id: id, level: 1)
  end

  def user_has_mod_permissions(u_id)
    if u_id == self.user_id
      return true
    end

    level = Role.requirement_role_level(u_id, self.id)

    if level < 2
      true
    else
      if Role.opportunity_role_level(u_id, self.opportunity_id) <= 2
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
    if status.size > 60
      errors.add(:status, "must be less than 60 characters")
    end
  end

  def completion_date_limit
    if target_completion_date > opportunity.target_completion_date
      errors.add(:target_completion_date, "cannot be after the Opportunity's target completion date.")
    end
  end

end
