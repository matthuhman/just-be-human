class AddCleanupIndex < ActiveRecord::Migration[6.0]
  def change
    add_index :cleanups, [:lat, :lng]
  end
end
