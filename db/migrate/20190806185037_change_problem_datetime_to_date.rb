class ChangeProblemDatetimeToDate < ActiveRecord::Migration[5.2]
  def change

    change_column :problems, :target_completion_date, :date
  end
end
