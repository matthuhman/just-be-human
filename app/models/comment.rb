require 'yaml'
require 'obscenity/active_model'

class Comment < ApplicationRecord

  belongs_to :user
  belongs_to :post

  validates_presence_of :content, message: "must be present."
  validates :content, obscenity: { sanitize: true, replacement: '[censored]' }




##################################################
#####################
#####################
#####################
#####################
##################### =>  20201205 abandoned
#####################
#####################
#####################
#####################
#####################
##################################################


  def edited?
    updated_at > created_at
  end
end
