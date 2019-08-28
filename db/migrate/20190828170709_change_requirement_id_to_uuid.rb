class ChangeRequirementIdToUuid < ActiveRecord::Migration[6.0]
  def change
    remove_column :requirement_roles, :requirement_id
  end
end
