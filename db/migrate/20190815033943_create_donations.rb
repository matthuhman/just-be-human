class CreateDonations < ActiveRecord::Migration[5.2]
  def change
    create_table :donations do |t|
      t.string :email, index: true, unique: true
      t.boolean :marketing, default: true
      t.boolean :donate, default: true
    end
  end
end
