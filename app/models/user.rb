class User < ApplicationRecord
  # Include default devise modules. Others available are:
  # :confirmable, :lockable, :timeoutable, :trackable and :omniauthable
  devise :database_authenticatable, :registerable,
         :recoverable, :rememberable, :validatable, :confirmable,
         :lockable, :timeoutable, :trackable

  has_many :problems
  has_many :roles
  has_many :milestone_roles, :dependent => :destroy
  has_many :posts, :dependent => :destroy
  has_many :comments, :dependent => :destroy


  after_destroy :fill_admin_roles







  private

    # TODO: if a user has any admin roles of problems that have > 1 follower, we want to take the highest-ranked other person
    # in the problem and promote them to leader so that 
    def fill_admin_roles

    end


end
