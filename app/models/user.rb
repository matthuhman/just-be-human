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
  has_many :contact_requests, :dependent => :destroy


  

  # before_save :validate

  def over_16?
    if self.over_16.nil?
      self.over_16 = self.birth_date < 18.year.ago
      self.save
    end

    return self.over_16
  end





  private

    def as_json(options = {})
      options[:except] ||= [:last_name, :email, :phone_number, :birth_date]
      super(options)
    end
end
