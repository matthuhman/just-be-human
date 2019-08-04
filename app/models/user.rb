class User < ApplicationRecord
  # Include default devise modules. Others available are:
  # :confirmable, :lockable, :timeoutable, :trackable and :omniauthable
  devise :database_authenticatable, :registerable,
         :recoverable, :rememberable, :validatable

  has_many :problems
  has_many :roles
  has_many :followed_problems, class_name: "Problem", foreign_key: "followed_problems_id"

end
