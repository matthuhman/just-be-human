require 'csv' 

class CreateGeopointsTable < ActiveRecord::Migration[5.2]
  def change
    create_table :geopoints do |t|
      t.string :zip
      t.string :city
      t.string :state
      t.decimal :latitude, precision: 7, scale: 5
      t.decimal :longitude, precision: 7, scale: 5
      t.integer :time_zone
      t.boolean :dst_flag
      t.string :coordinates
    end
  end
end
