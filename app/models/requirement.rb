require 'yaml'
require 'obscenity/active_model'

class Requirement < ApplicationRecord

  belongs_to :opportunity
  belongs_to :creator, class_name: "User", foreign_key: 'creator_id', optional: true
  belongs_to :leader, class_name: "User", foreign_key: 'leader_id', optional: true
  has_many :requirement_roles, :dependent => :destroy



  validates_presence_of :title, message: 'must be entered.'

  validates :title, obscenity: true

  # geocoded_by :address
  # after_validation :geocode, if: -> (obj) { obj.address.present? and obj.address_changed? }

  after_create :notify_create
  after_update :notify_update



##################################################
#####################
#####################
#####################
#####################
##################### =>  20201205 abandoned
#####################
#####################
#####################
#####################
#####################
##################################################






  def display_description
    if description.size > 100
      description[0..100] << "..."
    else
      description
    end
  end

  def display_date
    cleanup_date.to_date
  end

  def pct_done_display
    self.pct_done.round.to_s << "%"
  end

  def overdue?
    cleanup_date < Date.today && !complete
  end

  def can_complete?
    !complete && volunteer_count >= volunteers_required
  end

  def volunteers_needed?
    volunteer_count < volunteers_needed ? volunteers_needed - volunteer_count : 0
  end

  def latitude
    if address?
      super
    else
      opportunity.latitude
    end
  end

  def longitude
    address? ? super : opportunity.longitude
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
    self.volunteer_count -= 1
    if self.volunteer_count < self.volunteers_required && (self.status == "Ready" || self.complete?)
      if self.status == "Ready"
        self.status = "Need Volunteers"
      elsif self.complete
        self.status = "Need Volunteers"
        self.complete = false
      end
    end

    self.save
  end



  ## BEGIN PRIVATE METHODS
  private

  def recipients
    opportunity.opportunity_roles.map {|r| r.user}
  end

  def notify_create
    recipients.each do |r|
      if r.id != self.creator_id
        Notification.create(recipient: r, actor: User.find(self.creator_id), action: 'created', notifiable: self)
      end
    end
  end

  def notify_update
    recipients.each do |r|
      if r.id != self.creator_id
        Notification.create(recipient: r, actor: User.find(self.creator_id), action: 'updated', notifiable: self)
      end
    end
  end

  def field_length
    if title.size > 60
      errors.add(:title, "must be less than 60 characters")
    end
  end

  def completion_date_limit
    if cleanup_date > opportunity.cleanup_date
      errors.add(:cleanup_date, "cannot be after the Opportunity's target completion date.")
    end
  end

end
