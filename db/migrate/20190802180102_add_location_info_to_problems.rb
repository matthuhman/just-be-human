class AddLocationInfoToProblems < ActiveRecord::Migration[5.2]
  def change
    change_table :problems do |t|
      t.string :city, null: false, default: ""
      t.string :zip, null: false, default: ""
      t.string :state, null: false, default: ""
      t.string :country, null: false, default: "United States"
    end
  end
end
