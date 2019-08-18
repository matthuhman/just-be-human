class AddProblemIdToMsRole < ActiveRecord::Migration[5.2]
  def change
    add_column :milestone_roles, :problem_id, :integer
  end
end
