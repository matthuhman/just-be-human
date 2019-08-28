class AddRequirementIdToRequirementRoles < ActiveRecord::Migration[6.0]
  def change
    add_column :requirement_roles, :requirement_id, :uuid, index: true, references: "requirements"

    add_index :requirement_roles, [:user_id, :requirement_id]
  end
end
