class CreateCoordinates < ActiveRecord::Migration[6.0]
  def change
    create_table :coordinates do |t|
      t.references :opportunity
      t.decimal "lat", precision: 10, scale: 6
      t.decimal "lng", precision: 10, scale: 6
      t.timestamps
    end
  end
end
