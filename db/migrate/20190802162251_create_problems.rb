class CreateProblems < ActiveRecord::Migration[5.2]
  def change
    create_table :problems do |t|
      t.string :title, null: false, default: "Default Title. Change me!"
      t.text :description, null: false, default: "This is the default description. Please change me!"
      t.string :city, null: false, default: ""
      t.string :zip, null: false, default: ""
      t.string :state, null: false, default: ""
      t.string :country, null: false, default: "United States"
      t.decimal :latitude, precision: 18, scale: 15
      t.decimal :longitude, precision: 18, scale: 15
      t.date :target_completion_date, presence: true
      t.references :user, foreign_key: true
      t.integer :participants_required, default: 1
      t.integer :current_participant_count, default: 1
      t.boolean :completed, default: false
      t.timestamps
    end
  end
end
