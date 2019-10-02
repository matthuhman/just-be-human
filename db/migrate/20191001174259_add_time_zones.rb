class AddTimeZones < ActiveRecord::Migration[6.0]
  def change

    add_column :users, :time_zone, :string
    add_column :opportunities, :time_zone, :string
    add_column :requirements, :time_zone, :string
  end
end
