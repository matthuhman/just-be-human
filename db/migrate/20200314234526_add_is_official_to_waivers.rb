class AddIsOfficialToWaivers < ActiveRecord::Migration[6.0]
  def change
    add_column :waivers, :is_official, :boolean, default: false
  end
end
