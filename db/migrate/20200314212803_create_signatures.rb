class CreateSignatures < ActiveRecord::Migration[6.0]
  def change
    create_table :signatures, id: :uuid do |t|
      t.belongs_to :user, null: false, foreign_key: true, type: :uuid
      t.belongs_to :opportunity, null: false, foreign_key: true, type: :uuid
      t.belongs_to :waiver, null: false, foreign_key: true, type: :uuid

      t.string :user_salt, required: true
      t.string :signer_ip, required: true
      t.string :waiver_hash, required: true
      t.string :signature_sha256_hash, required: true

      t.timestamps
    end
  end
end
