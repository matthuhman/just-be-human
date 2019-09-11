class OpportunityRole < ApplicationRecord

  belongs_to :opportunity
  belongs_to :user
  before_destroy :fill_admin_role

  ## role level id 1 = LEADER
  ## role level id 2 = SUPERVISOR
  ## role level id 3 = VOLUNTEER
  ## role level id 4 = FOLLOWER


  private

  # TODO TODO TODO
  def fill_admin_role
    if self.level == 1
      puts 'We need to fill this role'
    else
      puts 'This role can be deleted'
    end
  end

end
