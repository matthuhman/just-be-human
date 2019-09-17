require 'yaml'
require 'obscenity/active_model'

class Comment < ApplicationRecord

  belongs_to :user
  belongs_to :post
  has_rich_text :content

  validates_presence_of :content, message: "must be present."
  validates :content, obscenity: { sanitize: true, replacement: '[censored]' }

end
