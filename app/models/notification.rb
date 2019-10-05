class Notification < ApplicationRecord
  belongs_to :recipient, class_name: 'User'
  belongs_to :actor, class_name: 'User'
  belongs_to :notifiable, polymorphic: true

  scope :unread, -> { where(read_at: nil) }


  def stringify
    if notifiable.class.name == "Post"
      "#{actor.username} #{action} a post in #{notifiable.postable.title}"
    elsif notifiable.class.name == "Requirement"
      "#{actor.username} #{action} a requirement in #{notifiable.opportunity.title}"
    elsif notifiable.class.name == "Opportunity"
      "#{actor.username} #{action} for #{notifiable.title}"
    end
  end
end
