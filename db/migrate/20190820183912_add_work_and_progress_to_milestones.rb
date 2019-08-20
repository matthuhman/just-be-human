class AddWorkAndProgressToMilestones < ActiveRecord::Migration[5.2]
  def change

    add_column :milestones, :priority, :integer, default: 1
    add_column :milestones, :estimated_work, :float, default: 1.0
    add_column :milestones, :pct_time_remaining, :float, default: 100
    add_column :milestones, :pct_work_remaining, :float, default: 100

    add_column :problems, :estimated_work, :float, default: 1.0
    add_column :problems, :pct_time_remaining, :float, default: 100
    add_column :problems, :pct_work_remaining, :float, default: 100
  end
end
