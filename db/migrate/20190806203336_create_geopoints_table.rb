require 'csv' 

class CreateGeopointsTable < ActiveRecord::Migration[5.2]
  def change
    create_table :geopoints do |t|
      t.string :zip, index: true, unique: true
      t.string :city
      t.string :state
      t.decimal :latitude, precision: 10, scale: 6
      t.decimal :longitude, precision: 10, scale: 6
      t.integer :time_zone
      t.boolean :dst_flag
      t.string :coordinates
    end
  end
end
