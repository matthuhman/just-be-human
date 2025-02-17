require 'yaml'
require 'obscenity/active_model'

class Opportunity < ApplicationRecord
  belongs_to :user

  has_many :opportunity_roles, :dependent => :destroy
  has_many :coordinates, :dependent => :destroy
  has_many :posts


  geocoded_by :latLng
  after_validation :geocode, if: -> (obj) { obj.latLng.present? and obj.latLng_changed? }


  validates_presence_of :title, message: "C'mon, you're not gonna name your zone?"


  validate :title_length

  validates :title, obscenity: true

  #################### 20201205 - commented out, but left here in case we decide to use desc again
  # validates :description, obscenity: { sanitize: true, replacement: '[censored]' }
  # validates_presence_of :description, message: 'You must enter a description.'



  def display_title
    title.size > 50 ? title[0,50] << "..." : title
  end


  def latLng
    [self.latitude, self.longitude]
  end

  def as_json(options = { })
    # just in case someone says as_json(nil) and bypasses
    # our default...
    super((options || { }).merge({
                                   :methods => [:overdue?]
    }))
  end



  private

    def title_length
      if title.size > 60
        errors.add(:title, "must be less than 60 characters")
      end
    end

      # Use callbacks to share common setup or constraints between actions.
    def set_opportunity
      @opportunity = Opportunity.find(params[:id])
    end
end





  ####### 20201204 - @mhuhman - these are no longer relevant for the rework
  # has_many :requirements, :dependent => :destroy
  # has_many :opportunity_waivers
  # has_many :waivers, through: :opportunity_waivers
  # has_many :signatures
  #######



  ## marks the Opportunity as complete and archives all existing posts
  # def mark_complete
  #   self.completed = true
  #   posts.each do |p|
  #     p.archived = true
  #     p.save
  #   end

  #   self.save
  # end

  # def mark_uncompleted
  #   self.completed = false
  #   posts.each do |p|
  #     p.archived = false
  #     p.save
  #   end

  #   self.posts.where(completion_post: true).last.destroy

  #   self.save
  # end


  # def can_complete?
  #   Time.now >= cleanup_date
  # end

  # def can_define?
  #   return if defined

  #   requirements.each do |r|
  #     if !r.defined
  #       return false
  #     end
  #   end
  #   true
  # end

  # def overdue?
  #   cleanup_date < Date.today
  # end

  # def day_id
  #   cleanup_date.strftime('%Y%m%d').to_i
  # end

  # def display_date
  #   cleanup_date.strftime('%m/%d/%Y')
  # end

###########################
############ 20201205 - we don't have start and end times, this logic will go into the "Reminder" system

              # def start_time
              #   Time.new(self.cleanup_date.year, self.cleanup_date.month, self.cleanup_date.day, self.cleanup_time.hour, self.cleanup_time.min)
              # end

              # def end_time
              #   self.start_time + self.cleanup_duration.hours
              # end





  ########################################
  ################### 20201205 - none of this matters any more
                        # def display_description
                        #   description.size > 160 ? description[0,160] << "..." : description
                        # end

                        # def volunteers_needed
                        #   self.volunteers_required - self.volunteer_count
                        # end

                        # def volunteers_fraction_string
                        #   "#{self.volunteer_count}/#{self.volunteers_required}"
                        # end

                        # def pct_time_remaining
                        #   total_time = self.cleanup_date.to_time.to_f - self.created_at.to_f
                        #   time_remaining = self.cleanup_date.to_time.to_f - Time.now.to_f

                        #   (time_remaining / total_time * 100).round
                        # end


                        # def pct_done
                        #   if self.planned?
                        #     return 0
                        #   end

                        #   est_work = self.estimated_work
                        #   work_done = 0.0
                        #   est_req_work = 0.0
                        #   self.requirements.each do |req|
                        #     work_done += (1 - (req.pct_done / 100)) * req.estimated_work
                        #     est_req_work += req.estimated_work
                        #   end

                        #   if work_done == 0
                        #     100.0
                        #   elsif est_work > est_req_work
                        #     work_done / est_work * 100
                        #   else
                        #     work_done / est_req_work * 100
                        #   end
                        # end


  #################### 20201205 - commented out because the PM system is on hold until people want it, KISS
#############################################
            # def self.users_are_volunteers(u1_id, u2_id, p_id = nil)
            #   if p_id != nil
            #     u1_role = OpportunityRole.find_by(user_id: u1_id, opportunity_id: p_id)
            #     u2_role = OpportunityRole.find_by(user_id: u2_id, opportunity_id: p_id)

            #     u1_role && u2_role && u1_role.level <= 3 && u2_role.level <= 3
            #   else
            #     u1_roles = OpportunityRole.where(user_id: u1_id).map { |r| r.level <= 3 ? r.opportunity_id : nil }
            #     u2_roles = OpportunityRole.where(user_id: u2_id).map{ |r| r.level <= 3 ? r.opportunity_id : nil }

            #     intersection = u1_roles & u2_roles

            #     intersection.size > 0
            #   end
            # end

  ###########################################
  ############## 20201205 - not sure how this stuck around for this long without getting commented out
                    # def defined_statuses
                    #   ['Need Volunteers', 'Ready', 'Complete']
                    # end


                    # def abstract_statuses
                    #   ['Planning', 'In Progress', 'Stuck', 'Expertise Needed', 'Ready']
                    # end






  ########## 20201205 commented out - still going to be useful in the future
  ########## TODO: figure out a way to set email reminders on a recurring weekly basis

  # def to_cal_json
  #   Jbuilder.encode do |json|
  #     json.start self.cleanup_date
  #     json.end (self.cleanup_date + 2.hours)
  #     json.title self.title
  #   end
  # end
