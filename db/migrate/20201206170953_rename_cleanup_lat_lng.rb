class RenameCleanupLatLng < ActiveRecord::Migration[6.0]
  def change
    rename_column :cleanups, :lat, :latitude
    rename_column :cleanups, :lng, :longitude
  end
end
