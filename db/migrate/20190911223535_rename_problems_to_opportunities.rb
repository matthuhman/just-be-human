class RenameProblemsToOpportunities < ActiveRecord::Migration[6.0]
  def change

    rename_table :problems, :opportunities
    rename_table :problem_roles, :opportunity_roles
  end
end
