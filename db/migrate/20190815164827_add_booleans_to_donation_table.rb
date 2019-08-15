class AddBooleansToDonationTable < ActiveRecord::Migration[5.2]
  def change
    add_column :donations, :donate, :boolean
    add_column :donations, :marketing, :boolean
    add_column :donations, :volunteer, :boolean
  end
end
