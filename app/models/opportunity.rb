require 'yaml'
require 'obscenity/active_model'

class Opportunity < ApplicationRecord
  belongs_to :user
  has_many :opportunity_roles, :dependent => :destroy
  has_many :requirements, :dependent => :destroy
  has_many :posts

  geocoded_by :address
  after_validation :geocode, if: -> (obj) { obj.address.present? and obj.address_changed? }


  validates_presence_of :title, message: 'You must enter a title.'
  validates_presence_of :description, message: 'You must enter a description.'
  validates_presence_of :address, :unless => :postal_code?, message: 'An address or postcode must be entered.'

  validate :title_length

  validates :title, obscenity: true
  validates :description, obscenity: { sanitize: true, replacement: '[censored]' }


  # marks the Opportunity as complete and archives all existing posts
  def mark_complete
    completed = true
    posts.each do |p|
      p.archived = true
      p.save
    end

    save
  end

  def mark_uncompleted
    completed = false
    posts.each do |p|
      p.archived = false
      p.save
    end

    posts.where(completion_post: true).last.destroy

    save
  end


  def can_complete?
    return unless defined
    enough_volunteers = volunteer_count >= volunteers_required
    at_completion_date = Time.now >= target_completion_date

    if enough_volunteers && at_completion_date
      requirements.each do |r|
        if !r.defined
          return false
        end
      end
      true
    else
      false
    end
  end

  def can_define?
    return if defined

    requirements.each do |r|
      if !r.defined
        return false
      end
    end
    true
  end

  def overdue?
    if defined
      target_completion_date? && target_completion_date < Date.today
    else
      planned_by_date? && planned_by_date < Date.today
    end
  end

  def display_date
    if defined
      target_completion_date.strftime('%Y/%m/%d - %l:%M%P')
    else
      if planned_by_date != nil
        planned_by_date.strftime('%Y/%m/%d')
      else
        nil
      end
    end
  end

  def display_title
    title.size > 50 ? title[0,50] << "..." : title
  end

  def display_description
    description.size > 160 ? description[0,160] << "..." : description
  end

  def category_title
    Category.opportunity_titles[self.category.to_i]
  end

  def volunteers_needed
    self.volunteers_required - self.volunteer_count
  end

  def volunteers_fraction_string
    "#{self.volunteer_count}/#{self.volunteers_required}"
  end

  def pct_time_remaining
    total_time = self.target_completion_date.to_time.to_f - self.created_at.to_f
    time_remaining = self.target_completion_date.to_time.to_f - Time.now.to_f

    (time_remaining / total_time * 100).round
  end


  def pct_done
    if self.planned?
      return 0
    end

    est_work = self.estimated_work
    work_done = 0.0
    est_req_work = 0.0
    self.requirements.each do |req|
      work_done += (1 - (req.pct_done / 100)) * req.estimated_work
      est_req_work += req.estimated_work
    end

    if work_done == 0
      100.0
    elsif est_work > est_req_work
      work_done / est_work * 100
    else
      work_done / est_req_work * 100
    end
  end


  def self.users_are_volunteers(u1_id, u2_id, p_id = nil)
    if p_id != nil
      u1_role = OpportunityRole.find_by(user_id: u1_id, opportunity_id: p_id)
      u2_role = OpportunityRole.find_by(user_id: u2_id, opportunity_id: p_id)

      u1_role && u2_role && u1_role.level <= 3 && u2_role.level <= 3
    else
      u1_roles = OpportunityRole.where(user_id: u1_id).map { |r| r.level <= 3 ? r.opportunity_id : nil }
      u2_roles = OpportunityRole.where(user_id: u2_id).map{ |r| r.level <= 3 ? r.opportunity_id : nil }

      intersection = u1_roles & u2_roles

      intersection.size > 0
    end
  end

  def defined_statuses
    ['Need Volunteers', 'Ready', 'Complete']
  end


  def abstract_statuses
    ['Planning', 'In Progress', 'Stuck', 'Expertise Needed', 'Ready']
  end


  def coordinates
    [self.latitude, self.longitude]
  end

  def as_json(options = { })
    # just in case someone says as_json(nil) and bypasses
    # our default...
    super((options || { }).merge({
                                   :methods => [:category_title, :overdue?, :pct_done]
    }))
  end

  private
  def title_length
    if title.size > 60
      errors.add(:title, "must be less than 60 characters")
    end
  end
end
