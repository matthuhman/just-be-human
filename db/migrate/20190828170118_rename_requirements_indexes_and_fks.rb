class RenameRequirementsIndexesAndFks < ActiveRecord::Migration[6.0]
  def change
    remove_index :requirement_roles, column: :milestone_id
    remove_index :requirement_roles, column: [:user_id, :milestone_id]

    remove_column :requirement_roles, :milestone_id

    add_reference :requirement_roles, :requirement, index: true
    add_index :requirement_roles, [:user_id, :requirement_id]
  end
end
