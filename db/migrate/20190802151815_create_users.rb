class CreateUsers < ActiveRecord::Migration[5.2]
  def change
    create_table :users do |t|
      t.string :username, index: true, unique: true
      t.string :first_name
      t.string :last_name
      t.string :city
      t.string :postal_code
      t.string :region
      t.string :country, default: "United States"
      t.timestamps
    end
  end
end
