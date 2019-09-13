class AddOpportunityIdToReqRoles < ActiveRecord::Migration[6.0]
  def change
    add_column :requirement_roles, :opportunity_id, :uuid

    add_index :requirement_roles, [:user_id, :opportunity_id]
  end
end
