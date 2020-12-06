require 'yaml'
require 'obscenity/active_model'

class User < ApplicationRecord
  devise :invitable, :database_authenticatable, :registerable,
    :recoverable, :rememberable,# :confirmable,
    :lockable, :timeoutable, :trackable, :validatable

  # has_many :visits, class_name: "Ahoy::Visit"

  ############# 20201205 TODO: I think we need to change this relationship to be 1:1,
  ############# => at least for now, however, I think it will technically work in its current state
  ############# => so we're just going to leave this alone for right now
  has_many :opportunity_roles, :dependent => :destroy
  has_many :opportunities, through: :opportunity_roles

  has_many :posts, :dependent => :destroy
  has_many :comments, :dependent => :destroy


  has_many :notifications, foreign_key: :recipient_id



                # has_many :requirement_roles, :dependent => :destroy
                # has_many :requirements, through: :requirement_roles

                # has_many :authored_conversations, class_name: 'Conversation', foreign_key: 'author_id'
                # has_many :received_conversations, class_name: 'Conversation', foreign_key: 'received_id'

                # has_many :personal_messages, :dependent => :destroy

                # has_many :waivers
                # has_many :signatures

                # profanity validations

  validate :username_allowed
  validates :username, obscenity: true
  validates :first_name, obscenity: true


##################### 20201205 - commented out because we're removing the idea of roles almost entirely
##################### => except as a 1:1 link for now, however, I don't want to remove the entire role architecture. Just in case.
                        # def over_16?
                        #   if over_16.nil?
                        #     self.over_16 = self.birth_date < 18.year.ago
                        #     self.save
                        #   end
                        #   return self.over_16
                        # end


                        # def is_admin?(oppo_id)
                        #   role = opportunity_roles.find_by(opportunity_id: oppo_id)

                        #   role && role.level == 1
                        # end

                        # def is_mod?(oppo_id)
                        #   role = opportunity_roles.find_by(opportunity_id: oppo_id)

                        #   role && role.level <= 2
                        # end

                        # def is_volunteer?(oppo_id)
                        #   role = opportunity_roles.find_by(opportunity_id: oppo_id)

                        #   role && role.level <= 3
                        # end

                        # # def is_req_volunteer?(req_id)
                        # #   !requirement_roles.find_by(requirement_id: req_id).nil?
                        # # end

                        # def is_confirmed?(oppo_id)
                        #   role = opportunity_roles.find_by(opportunity_id: oppo_id)

                        #   role && role.level <= 4
                        # end


                        # def is_follower?(oppo_id)
                        #   role = opportunity_roles.find_by(opportunity_id: oppo_id)

                        #   role && role.level <= 5
                        # end


  def as_json(options = {})
    options[:except] ||= [:last_name, :email, :phone_number, :birth_date]
    super(options)
  end


  def username_allowed
    forbidden = ["admin", "adm1n", "4dm1n", "4dmin", "administrator", "mod", "moderator",  #
                 "leader", "matthuhman", "owner", "founder", "root", "employee", "test", "tester"]
    if forbidden.include? username.downcase
      errors.add(:username, 'is forbidden.')
    end
  end

end
