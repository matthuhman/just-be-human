class MakeRequirementRolesUnique < ActiveRecord::Migration[6.0]
  def change
    remove_index :requirement_roles, column: [:user_id, :requirement_id]
  end
end
