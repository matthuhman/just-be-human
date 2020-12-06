class AddLastCleanupTime < ActiveRecord::Migration[6.0]
  def change
      add_column :opportunities, :last_cleanup_time, :datetime, :default => DateTime.now
  end
end
