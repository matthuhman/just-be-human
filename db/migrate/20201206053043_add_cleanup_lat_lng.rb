class AddCleanupLatLng < ActiveRecord::Migration[6.0]
  def change
    add_column :cleanups, :lat, :decimal, precision: 10, scale: 6
    add_column :cleanups, :lng, :decimal, precision: 10, scale: 6
    add_column :cleanups, :description, :string
  end
end
