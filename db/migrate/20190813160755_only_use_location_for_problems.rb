class OnlyUseLocationForProblems < ActiveRecord::Migration[5.2]
  def change

    remove_column :problems, :city
    remove_column :problems, :state
    remove_column :problems, :zip
    remove_column :problems, :country
    
  end
end
