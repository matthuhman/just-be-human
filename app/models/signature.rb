class Signature < ApplicationRecord
  belongs_to :user
  belongs_to :opportunity
  belongs_to :waiver

  after_create :generate_sha256_hash




  private

  def generate_sha256_hash
    self.signature_sha256_hash = Digest::SHA256.digest self.user_salt + self.signer_ip + self.waiver_hash + self.opportunity.id + self.created_at
    self.save
  end


end
