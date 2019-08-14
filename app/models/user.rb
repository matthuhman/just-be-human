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

    def fill_admin_roles

    end


end
