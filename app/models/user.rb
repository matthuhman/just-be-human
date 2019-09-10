require 'yaml'
require 'obscenity/active_model'

class User < ApplicationRecord
  devise :database_authenticatable, :registerable,
    :recoverable, :rememberable, :validatable, :confirmable,
    :lockable, :timeoutable, :trackable

  has_many :problems
  has_many :problem_roles, :dependent => :destroy
  has_many :requirements
  has_many :requirement_roles, :dependent => :destroy
  has_many :posts, :dependent => :destroy
  has_many :comments, :dependent => :destroy

  has_many :authored_conversations, class_name: 'Conversation', foreign_key: 'author_id'
  has_many :received_conversations, class_name: 'Conversation', foreign_key: 'received_id'
  has_many :personal_messages, :dependent => :destroy


  # profanity validations
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


  def is_admin?(type, type_id)
    if type == "problem"
      lvl = Role.problem_role_level(id, type_id)

      (lvl && lvl < 2)
    else
      lvl = Role.requirement_role_level(id, type_id)

      if lvl && lvl < 2
        true
      else
        parent = Problem.find(Requirement.find(type_id).problem_id)
        lvl = Role.problem_role_level(id, parent.id)

        (lvl && lvl < 2)
      end
    end
  end

  def is_mod?(type, type_id)
    if type == "problem"
      lvl = Role.problem_role_level(id, type_id)

      (lvl && lvl <= 2)
    else
      lvl = Role.requirement_role_level(id, type_id)

      if lvl && lvl <= 2
        true
      else
        parent = Problem.find(Requirement.find(type_id).problem_id)
        lvl = Role.problem_role_level(id, parent.id)

        (lvl && lvl <= 2)
      end
    end
  end


  def can_post


  end


  def can_message



  end



  def as_json(options = {})
    options[:except] ||= [:last_name, :email, :phone_number, :birth_date]
    super(options)
  end



  # private
  # def censor_text_input
  #   binding.pry
  #   if Obscenity.profane?(username) || Obscenity.profane?(first_name) || Obscenity.profane?(last_name)
  #     errors.add(:username, " and first/last names cannot be profane.")
  #     err = "First name: #{first_name} ::: #{last_name} ::: Username: #{username} ::: Email: #{email}"
  #     ReportedError.report("profane_username", err, 666)
  #   end

  #   if Obscenity.profane?(city) || Obscenity.profane?(region)
  #     errors.add(:city, "and region cannot contain profanity.")
  #   end

  #   if first_name =~ /\d/
  #     errors.add(:first_name, "cannot contain numbers.")
  #   end

  #   if last_name =~ /\d/
  #     errors.add(:last_name, "cannot contain numbers")
  #   end
  # end
end
