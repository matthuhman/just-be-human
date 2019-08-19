class CreateCosts < ActiveRecord::Migration[5.2]
  def change
    create_table :costs, id: :uuid do |t|
      t.date :fetch_date, default: -> { 'CURRENT_TIMESTAMP' }, index: true
      t.float :daily_cost
      t.float :mtd_cost
      t.float :estimated_monthly_cost
      t.timestamps
    end
  end
end
