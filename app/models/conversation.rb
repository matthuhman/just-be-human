class Conversation < ApplicationRecord

  belongs_to :author, class_name: "User"
  belongs_to :receiver, class_name: "User"

  has_many :personal_messages, -> { order('personal_messages.created_at ASC') }, dependent: :destroy

  validates :author, uniqueness: {scope: :receiver}


  scope :participating, -> (user) do
    where("(conversations.author_id = ? OR conversations.receiver_id = ?)", user.id, user.id).limit(1)
  end

  scope :between, -> (sender_id, receiver_id) do
    where(author_id: sender_id, receiver_id: receiver_id).or(where(author_id: receiver_id, receiver_id: sender_id)).limit(1)
  end


  def self.can_have_conversation(u1, u2, p_id = nil)
    if p_id != nil
      both_over16 = u1.over_16? && u2.over_16?

      Opportunity.users_are_volunteers(u1.id, u2.id, p_id) <= 3 && both_over16
    else
      u1_roles = OpportunityRole.where(user_id: u1.id).map { |r| r.level <= 3 ? r.opportunity_id : nil }
      u2_roles = OpportunityRole.where(user_id: u2.id).map{ |r| r.level <= 3 ? r.opportunity_id : nil }

      intersection = u1_roles & u2_roles
      both_over16 = u1.over_16? && u2.over_16?

      intersection.size > 0 && both_over16
    end
  end


  def with(current_user)
    author == current_user ? receiver : author
  end

  ##
  def participates?(user)
    author == user || receiver == user
  end

end
