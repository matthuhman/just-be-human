class OpportunityRole < ApplicationRecord

  belongs_to :opportunity
  belongs_to :user

  after_create :send_follow_email

  ## role level id 1 = LEADER
  ## role level id 2 = SUPERVISOR
  ## role level id 3 = VOLUNTEER
  ## role level id 4 = FOLLOWER


  private


  def send_follow_email
    OpportunityMailer.follow_email(self.user, self.opportunity)
  end

end
