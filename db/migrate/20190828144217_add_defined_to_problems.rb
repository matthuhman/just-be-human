class AddDefinedToProblems < ActiveRecord::Migration[6.0]
  def change

    add_column :problems, :planned, :boolean, default: true

    remove_index :problems, column: [:category, :subcategory]
    remove_column :problems, :subcategory

    

    add_index :problems, [:planned, :category]

  end
end
