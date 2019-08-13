class MakeProblemLatLongFloat < ActiveRecord::Migration[5.2]
  def change
    change_column :problems, :latitude, :float
    change_column :problems, :longitude, :float
  end
end
