class RemoveFloatLatLngFromProblems < ActiveRecord::Migration[5.2]
  def change
    remove_column :problems, :float_lat
    remove_column :problems, :float_long
  end
end
