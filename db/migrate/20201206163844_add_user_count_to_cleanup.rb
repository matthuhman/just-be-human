class AddUserCountToCleanup < ActiveRecord::Migration[6.0]
  def change
    add_column :cleanups, :participants, :integer, default: 1
  end
end
