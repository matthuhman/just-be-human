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



  def display_description
    if description.size > 100
      description[0..100] << "..."
    else
      description
    end
  end

  def pct_done_display
    self.pct_done.round.to_s << "%"
  end

  def overdue?
    (target_completion_date < Date.today) && !complete
  end

  def can_complete?
    !complete && volunteer_count >= volunteers_required
  end

  def leader
    requirement_roles.find_by(requirement_id: id, level: 1)
  end

  def abstract_statuses
    ["Open", "In Progress", "Need Volunteers", "Ready", "Waiting", "Expertise Needed", "Planning"]
  end

  def defined_statuses
    ["Need Volunteers", "In Progress", "Ready"]
  end

  def category_title
    Category.req_titles[self.category.to_i]
  end

  def subcategory_title
    Category.req_subcat_titles(self.category.to_i)[self.subcategory.to_i]
  end


  def add_volunteer
    self.volunteer_count += 1
    if self.volunteer_count >= self.volunteers_required
      self.status = "Ready"
    end

    self.save
  end

  def subtract_volunteer
    # binding.pry
    self.volunteer_count -= 1
    if self.volunteer_count < self.volunteers_required && (self.status == "Ready" || self.complete?)
      if self.status == "Ready"
        self.status = "Need Volunters"
      elsif self.complete
        self.status = "Need Volunteers"
        self.complete = false
      end
    end

    self.save
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
