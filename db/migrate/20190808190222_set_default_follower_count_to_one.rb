class SetDefaultFollowerCountToOne < ActiveRecord::Migration[5.2]
  def change

    change_column_default :problems, :follower_count, 1
    change_column_default :milestones, :participant_count, 1
    change_column_default :milestones, :participants_required, 1
  end
end
