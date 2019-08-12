class User < ApplicationRecord
  # Include default devise modules. Others available are:
  # :confirmable, :lockable, :timeoutable, :trackable and :omniauthable
  devise :database_authenticatable, :registerable,
         :recoverable, :rememberable, :validatable #:confirmable,
         #:lockable, :timeoutable, :trackable

  has_many :problems
  has_many :roles
  has_many :milestone_roles

end
