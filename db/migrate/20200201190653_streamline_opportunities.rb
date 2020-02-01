class StreamlineOpportunities < ActiveRecord::Migration[6.0]
  def change

    remove_index :opportunities, [:planned, :category]
    remove_column :opportunities, :category
    remove_column :opportunities, :defined
    remove_column :opportunities, :planned
    remove_column :opportunities, :estimated_work
    remove_column :opportunities, :recurring_period
    remove_column :opportunities, :planned_by_date
  end
end
