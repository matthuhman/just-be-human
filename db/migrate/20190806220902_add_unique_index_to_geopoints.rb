class AddUniqueIndexToGeopoints < ActiveRecord::Migration[5.2]
  def change

    add_index :geopoints, :zip, unique: true
  end
end
