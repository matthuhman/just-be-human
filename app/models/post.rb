require 'yaml'
require 'obscenity/active_model'

class Post < ApplicationRecord

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
end
