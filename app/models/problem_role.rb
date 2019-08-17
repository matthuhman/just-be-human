class ProblemRole < ApplicationRecord

  belongs_to :problem
  belongs_to :user
  before_destroy :fill_admin_role

  ## role level id 1 = ADMIN
  ## role level id 2 = MODERATOR
  ## role level id 3 = PARTICIPANT


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
