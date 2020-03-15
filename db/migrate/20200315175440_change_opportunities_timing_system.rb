class ChangeOpportunitiesTimingSystem < ActiveRecord::Migration[6.0]
  def change
    rename_column :opportunities, :target_completion_date, :cleanup_date
    change_column :opportunities, :cleanup_date, :date
    add_column :opportunities, :cleanup_time, :time
    add_column :opportunities, :cleanup_duration, :integer, default: 2
  end
end
