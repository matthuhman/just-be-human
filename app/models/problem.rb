require 'yaml'
require 'obscenity/active_model'

class Problem < ApplicationRecord
  belongs_to :user
  has_many :problem_roles, :dependent => :destroy
  has_many :requirements, :dependent => :destroy
  has_many :posts, as: :postable, :dependent => :destroy

  geocoded_by :address
  after_validation :geocode, if: -> (obj) { obj.address.present? and obj.address_changed? }


  validates_presence_of :title, message: 'You must enter a title.'
  validates_presence_of :description, message: 'You must enter a description.'
  validates_presence_of :address, :unless => :postal_code?, message: 'An address or postcode must be entered.'

  validate :title_length

  validates :title, obscenity: true
  validates :description, obscenity: { sanitize: true, replacement: '[censored]' }

  def user_is_admin(user_id)
    user_id == self.user_id
  end


  def user_has_mod_permissions(user_id)
    if user_id == self.user_id
      return true
    end

    role = ProblemRole.find_by(user_id: user_id, problem_id: self.id)

    role && role.level <= 2
  end

  def display_title
    title.size > 50 ? title[0,50] << "..." : title
  end

  def display_description
    description.size > 160 ? description[0,160] << "..." : description
  end

  def category_title
    Category.problem_titles[self.category.to_i]
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


  def pct_work_remaining
    if self.planned?
      return 0
    end

    est_work = self.estimated_work
    work_done = 0.0
    est_req_work = 0.0
    self.requirements.each do |req|
      work_done += (1 - (req.pct_work_remaining / 100)) * req.estimated_work
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
      u1_role = ProblemRole.find_by(user_id: u1_id, problem_id: p_id)
      u2_role = ProblemRole.find_by(user_id: u2_id, problem_id: p_id)

      u1_role && u2_role && u1_role.level <= 3 && u2_role.level <= 3
    else
      u1_roles = ProblemRole.where(user_id: u1_id).map { |r| r.level <= 3 ? r.problem_id : nil }
      u2_roles = ProblemRole.where(user_id: u2_id).map{ |r| r.level <= 3 ? r.problem_id : nil }

      intersection = u1_roles & u2_roles

      intersection.size > 0
    end
  end


  def coordinates
    [self.latitude, self.longitude]
  end

  def as_json(options = { })
    # just in case someone says as_json(nil) and bypasses
    # our default...
    super((options || { }).merge({
                                   :methods => [:category_title]
    }))
  end

  private
  def title_length
    if title.size > 60
      errors.add(:title, "must be less than 60 characters")
    end
  end
end
