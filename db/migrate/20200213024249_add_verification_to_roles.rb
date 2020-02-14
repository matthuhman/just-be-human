class AddVerificationToRoles < ActiveRecord::Migration[6.0]
  def change
    change_table :opportunity_roles do |t|
      t.boolean :self_verified
      t.boolean :leader_verified
      t.boolean :leader_was_present

      t.datetime :self_verified_at
      t.datetime :leader_verified_at
    end
  end
end
