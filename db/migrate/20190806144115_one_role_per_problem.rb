class OneRolePerProblem < ActiveRecord::Migration[5.2]
  def change
    add_index :roles, [:user_id, :problem_id], unique: true
  end
end
