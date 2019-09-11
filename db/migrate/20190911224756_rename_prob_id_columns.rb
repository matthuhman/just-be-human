class RenameProbIdColumns < ActiveRecord::Migration[6.0]
  def change

    rename_column :opportunity_roles, :problem_id, :opportunity_id
    remove_column :requirement_roles, :problem_id
    rename_column :requirements, :problem_id, :opportunity_id

  end
end
