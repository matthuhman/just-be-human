class RemovePercentTimeRemaining < ActiveRecord::Migration[5.2]
  def change
    remove_column :problems, :pct_time_remaining
    remove_column :problems, :pct_work_remaining
    remove_column :milestones, :pct_time_remaining
  end
end
