class AddLocationColumnsBackToProblems < ActiveRecord::Migration[5.2]
  def change
    add_column :problems, :postal_code, :string
    add_column :problems, :country, :string, default: "United States"
  end
end
