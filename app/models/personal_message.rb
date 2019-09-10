require 'yaml'
require 'obscenity/active_model'

class PersonalMessage < ApplicationRecord
  belongs_to :conversation
  belongs_to :user


  validates :body, presence: true
  validates :body, obscenity: { sanitize: true, replacement: '[censored]'}

end
