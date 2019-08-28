class RenameMilestonesToRequirements < ActiveRecord::Migration[6.0]
  def change

    rename_table :milestones, :requirements
    rename_table :milestone_roles, :requirement_roles
    
  end
end
