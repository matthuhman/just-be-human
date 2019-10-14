require 'yaml'
require 'obscenity/active_model'

class Post < ApplicationRecord

  after_create :notify_create

  belongs_to :user
  belongs_to :postable, polymorphic: true
  has_many :comments, dependent: :destroy
  has_rich_text :content

  validates_presence_of :title, message: "must be present."
  validates_presence_of :content, message: "must be present."

  # profanity validations
  validates :title, obscenity: true
  validates :content, obscenity: true

  def display_timestamp
    self.created_at.strftime("%l:%M%P on %-m/%-d/%y")
  end

  def display_title
    title.size > 30 ? title[0..30] + "..." : title
  end


  private

  def recipients
    if self.postable_type == "Opportunity"
      roles = OpportunityRole.where(opportunity_id: self.postable_id)
      roles.map { |r| r.user }
    else
      req = Requirement.find(self.postable_id)
      roles = req.opportunity.opportunity_roles
      roles.map { |r| r.user }
    end
  end


  def notify_create
    recipients.each do |rec|
      if rec != self.user
        Notification.create(recipient: rec, actor: self.user, action: 'posted', notifiable: self)
      end
    end
  end
end
