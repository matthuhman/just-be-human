class CreateCosts < ActiveRecord::Migration[5.2]
  def change
    create_table :costs do |t|
      t.date :fetch_date, default: -> { 'CURRENT_TIMESTAMP' }
      t.float :daily_cost
      t.float :mtd_cost
      t.float :estimated_monthly_cost
      t.timestamps
    end
  end
end
