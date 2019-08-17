class AddResources < ActiveRecord::Migration[5.2]
  def change
    create_table :resources do |t|
      t.integer :code, index: true
      t.string :title
      t.integer :category
      t.integer :subcategory
    end

    create_table :user_resources do |t|

      t.belongs_to :user, index: true
      t.belongs_to :resouces, index: true

      t.timestamps
    end
  end
end
