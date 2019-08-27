class AddRecurringAndDefinedFlagsToProblems < ActiveRecord::Migration[6.0]
  def change
    add_column :problems, :recurring, :boolean, default: false
    add_column :problems, :recurring_period, :datetime


    add_column :problems, :defined, :boolean, default: true
    
  end
end
