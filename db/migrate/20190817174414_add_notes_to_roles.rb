class AddNotesToRoles < ActiveRecord::Migration[5.2]
  def change
    add_column :problem_roles, :notes, :string
    add_column :milestone_roles, :notes, :string
  end
end
