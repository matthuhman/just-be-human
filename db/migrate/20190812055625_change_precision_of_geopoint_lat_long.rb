class ChangePrecisionOfGeopointLatLong < ActiveRecord::Migration[5.2]
  
  change_column :geopoints, :latitude, :decimal, :precision => 9, :scale => 6
  change_column :geopoints, :longitude, :decimal, :precision => 9, :scale => 6
  
end
