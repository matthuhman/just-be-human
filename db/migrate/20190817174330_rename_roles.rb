class RenameRoles < ActiveRecord::Migration[5.2]
  def change
    rename_table :roles, :problem_roles
  end
end
