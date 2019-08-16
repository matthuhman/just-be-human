class CreateProblems < ActiveRecord::Migration[5.2]
  def change
    create_table :problems do |t|
      t.string :title
      t.text :description
      t.decimal :latitude, precision: 10, scale: 6
      t.decimal :longitude, precision: 10, scale: 6
      t.date :target_completion_date
      t.bigint :user_id
      t.integer :volunteers_required, default: 1
      t.integer :volunteer_count, default: 1
      t.boolean :completed, default: false
      
      t.string :address
      t.string :postal_code
      t.string :category
      t.string :subcategory
      t.integer :follower_count, default: 1
      
      t.belongs_to :user, index: true

      t.timestamps

      t.index [:category, :subcategory], name: "index_problems_on_category_and_subcategory"
      t.index [:latitude, :longitude], name: "index_problems_on_latitude_and_longitude"
      
    end
  end
end
