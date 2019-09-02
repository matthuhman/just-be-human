class Comment < ApplicationRecord

  belongs_to :user
  belongs_to :post
  # has_rich_text :content

  validates_presence_of :content, message: "must be present."
  
end
