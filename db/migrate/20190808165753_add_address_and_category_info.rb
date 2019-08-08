class AddAddressAndCategoryInfo < ActiveRecord::Migration[5.2]
  def change

    add_column :problems, :address, :string
    add_column :problems, :category, :string
    add_column :problems, :subcategory, :string


    add_column :milestones, :address, :string
  end
end
