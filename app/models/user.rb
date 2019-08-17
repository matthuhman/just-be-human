class User < ApplicationRecord
  devise :database_authenticatable, :registerable,
         :recoverable, :rememberable, :validatable, :confirmable,
         :lockable, :timeoutable, :trackable

  has_many :problems
  has_many :problem_roles, :dependent => :destroy
  has_many :milestones
  has_many :milestone_roles, :dependent => :destroy
  has_many :posts, :dependent => :destroy
  has_many :comments, :dependent => :destroy


  

  # before_save :validate

  def over_16?
    if self.over_16.nil?
      self.over_16 = self.birth_date < 18.year.ago
      self.save
    end

    return self.over_16
  end



  private

    # TODO: if a user has any admin roles of problems that have > 1 follower, we want to take the highest-ranked other person
    # in the problem and promote them to leader so that 
    def fill_admin_roles

    end


end
