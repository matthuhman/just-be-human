class CreateUsers < ActiveRecord::Migration[5.2]
  def change
    create_table :users do |t|
      t.string :username
      t.string :first_name
      t.string :last_name
      t.string :city, null: false, default: ""
      t.string :zip, null: false, default: ""
      t.string :state, null: false, default: ""
      t.string :country, null: false, default: "United States"
      t.timestamps
    end
  end
end
