class AddLatLongToWaivers < ActiveRecord::Migration[6.0]
  def change

    add_column :waivers, :lat, :decimal, precision: 10, scale: 6
    add_column :waivers, :long, :decimal, precision: 10, scale: 6
    add_column :waivers, :state_code, :string
  end
end
