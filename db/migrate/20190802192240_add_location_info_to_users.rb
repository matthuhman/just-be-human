class AddLocationInfoToUsers < ActiveRecord::Migration[5.2]
  def change
    change_table :users do |t|
      t.string :city, null: false, default: ""
      t.string :zip, null: false, default: ""
      t.string :state, null: false, default: ""
      t.string :country, null: false, default: "United States"
    end
  end
end
