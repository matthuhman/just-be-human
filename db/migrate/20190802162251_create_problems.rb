class CreateProblems < ActiveRecord::Migration[5.2]
  def change
    create_table :problems, id: :uuid do |t|
      t.string :title
      t.text :description
      t.decimal :latitude, precision: 10, scale: 6
      t.decimal :longitude, precision: 10, scale: 6
      t.float :float_lat
      t.float :float_long
      t.date :target_completion_date
      t.integer :volunteers_required, default: 1
      t.integer :volunteer_count, default: 1
      t.boolean :completed, default: false
      
      t.string :address
      t.string :postal_code
      t.integer :category
      t.integer :subcategory
      t.integer :follower_count, default: 1
      
      t.belongs_to :user, type: :uuid, index: true

      t.timestamps

      t.index [:category, :subcategory], name: "index_problems_on_category_and_subcategory"
      t.index [:latitude, :longitude], name: "index_problems_on_latitude_and_longitude"
      
    end
  end
end
