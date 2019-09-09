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
  #has_many :outbound_requests, foreign_key: "requesting_user_id", class_name: "ContactRequest", :dependent => :destroy
  #has_many :inbound_requests, foreign_key: "requested_user_id", class_name: "ContactRequest", :dependent => :destroy 


  has_many :authored_conversations, class_name: 'Conversation', foreign_key: 'author_id'
  has_many :received_conversations, class_name: 'Conversation', foreign_key: 'received_id'
  has_many :personal_messages, :dependent => :destroy
  # ...


  validate :number_free_names
  

  # before_save :validate

  def over_16?
    if self.over_16.nil?
      self.over_16 = self.birth_date < 18.year.ago
      self.save
    end
    return self.over_16
  end


  def get_active_contact_requests(problem_id)
    reqs = ContactRequest.where(requested_user_id: self.id, problem_id: problem_id)





  end





  private

    def number_free_names
      if first_name =~ /\d/
        errors.add(:first_name, "cannot contain numbers.")
      end

      if last_name =~ /\d/
        errors.add(:last_name, "cannot contain numbers")
      end
    end

    def as_json(options = {})
      options[:except] ||= [:last_name, :email, :phone_number, :birth_date]
      super(options)
    end
end
