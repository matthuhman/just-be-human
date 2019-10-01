require 'yaml'
require 'obscenity/active_model'

class User < ApplicationRecord
  devise :database_authenticatable, :registerable,
    :recoverable, :rememberable, :validatable, :confirmable,
    :lockable, :timeoutable, :trackable

  # has_many :visits, class_name: "Ahoy::Visit"

  has_many :opportunity_roles, :dependent => :destroy
  has_many :opportunities, through: :opportunity_roles

  has_many :requirement_roles, :dependent => :destroy
  has_many :requirements, through: :requirement_roles

  has_many :posts, :dependent => :destroy
  has_many :comments, :dependent => :destroy

  has_many :authored_conversations, class_name: 'Conversation', foreign_key: 'author_id'
  has_many :received_conversations, class_name: 'Conversation', foreign_key: 'received_id'

  has_many :personal_messages, :dependent => :destroy
  has_many :notifications, foreign_key: :recipient_id

  # profanity validations
  validates_uniqueness_of :username, message: 'is already taken.'
  validate :username_allowed
  validates :username, obscenity: true
  validates :first_name, obscenity: true
  validates :last_name, obscenity: true
  validates :city, obscenity: true
  validates :region, obscenity: true


  # before_save :validate

  def over_16?
    if over_16.nil?
      self.over_16 = self.birth_date < 18.year.ago
      self.save
    end
    return self.over_16
  end


  def is_admin?(oppo_id)
    role = opportunity_roles.find_by(opportunity_id: oppo_id)

    role && role.level == 1
  end

  def is_mod?(oppo_id)
    role = opportunity_roles.find_by(opportunity_id: oppo_id)

    role && role.level <= 2
  end

  def is_volunteer?(oppo_id)
    role = opportunity_roles.find_by(opportunity_id: oppo_id)

    role && role.level <= 3
  end

  def is_req_volunteer?(req_id)
    !requirement_roles.find_by(requirement_id: req_id).nil?
  end

  def is_confirmed?(oppo_id)
    role = opportunity_roles.find_by(opportunity_id: oppo_id)

    role && role.level <= 4
  end


  def is_follower?(oppo_id)
    role = opportunity_roles.find_by(opportunity_id: oppo_id)

    role && role.level <= 5
  end



  def as_json(options = {})
    options[:except] ||= [:last_name, :email, :phone_number, :birth_date]
    super(options)
  end


  def username_allowed
    forbidden = ["admin", "administrator", "mod", "moderator", "leader", "matthuhman", "owner", "founder", "root", "employee"]

    forbidden.each do |f|
      # if f.casecmp(username)
      #   errors.add(:username, "is forbidden.")
      #   return
      # end
    end
  end
end
