class AddUniqueIndexToRequirementRoles < ActiveRecord::Migration[6.0]
  def change
    add_index :requirement_roles, [:user_id, :requirement_id], unique: true, name: "idx_one_role_per_user"
  end
end
