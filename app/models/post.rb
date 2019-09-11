require 'yaml'
require 'obscenity/active_model'

class Post < ApplicationRecord

  belongs_to :postable, polymorphic: true
  has_many :comments
  # has_rich_text :content

  validates_presence_of :title, message: "must be present."
  validates_presence_of :content, message: "must be present."

  # profanity validations
  validates :title, obscenity: true
  validates :content, obscenity: { sanitize: true, replacement: '[censored]'}

  def user_has_permissions(user_id)
    if (self.postable_type == "Requirement")
      return Requirement.find(self.postable_id).user_has_mod_permissions(user_id)
    else
      return Opportunity.find(self.postable_id).user_has_mod_permissions(user_id)
    end
  end

  def display_content
    if !content
      nil
    elsif content.size > 100
      content[0, 100] << "..."
    else
      content
    end
  end

  def display_timestamp
    self.created_at.strftime("%l:%M%P on %-m/%-d/%y")
  end

  def user_can_comment(user_id)
    if (self.postable_type == 'Opportunity')
      role = OpportunityRole.find_by(user_id: user_id, opportunity_id: self.postable_id)
      if role
        return true
      end
    else
      opportunity_id = Requirement.find(self.postable_id).opportunity_id
      role = OpportunityRole.find_by(user_id: user_id, opportunity_id: opportunity_id)
      if role
        return true;
      end
    end

    return false
  end
end
