class AddCountsToMilestones < ActiveRecord::Migration[5.2]
  def change
    add_column :milestones, :participants_required, :integer
    add_column :milestones, :participant_count, :integer


    add_column :problems, :follower_count, :integer
    rename_column :problems, :current_participant_count, :participant_count
  end
end
