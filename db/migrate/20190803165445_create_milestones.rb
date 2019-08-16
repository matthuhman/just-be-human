class CreateMilestones < ActiveRecord::Migration[5.2]
  def change
    create_table :milestones do |t|
      t.string :title
      t.text :description
      t.string :address
      t.decimal :latitude, precision: 10, scale: 6
      t.decimal :longitude, precision: 10, scale: 6
      t.integer :volunteers_required, default: 1
      t.integer :volunteer_count, default: 1
      t.integer :category
      t.integer :subcategory
      t.boolean :complete
      t.string :current_status


      t.belongs_to :problem, index: true
      t.belongs_to :user, index: true

      t.index [:category, :subcategory], name: "index_milestones_on_category_and_subcategory"
      t.index [:latitude, :longitude], name: "index_milestones_on_latitude_and_longitude"

      t.timestamps
    end
  end
end
