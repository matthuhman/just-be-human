class CreateCleanupZones < ActiveRecord::Migration[6.1]
  def change
    create_table :cleanup_zones do |t|
      t.belongs_to :user
      t.decimal :latitude, precision: 10, scale: 6
      t.decimal :longitude, precision: 10, scale: 6
      t.datetime :last_cleanup_time
      t.timestamps
    end

    change_table :coordinates do |t|
      t.remove_references :cleanup
    end

    change_table :coordinates do |t|
      t.belongs_to :cleanup_zone
    end
  end
end
