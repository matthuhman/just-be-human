class AddDueDateToMilestones < ActiveRecord::Migration[5.2]
  def change
    add_column :milestones, :target_completion_date, :date
  end
end
