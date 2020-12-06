class Signature < ApplicationRecord
  belongs_to :user
  belongs_to :opportunity
  belongs_to :waiver

  # TODO: add field validations to model
  # validates_presence_of :

  after_create :generate_sha256_hash

  @@digest = nil



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

  def self.get_digest(to_digest)
    if !@@digest
      @@digest = Digest::SHA256
    end
    @@digest.base64digest to_digest
  end

  private

  def generate_sha256_hash
    self.signature_sha256_hash = Signature.get_digest(self.user_salt + self.signer_ip + self.waiver_hash + self.opportunity.id + self.created_at.to_s)
    binding.pry
    self.save
  end


end
