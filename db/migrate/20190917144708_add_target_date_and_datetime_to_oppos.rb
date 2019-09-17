class AddTargetDateAndDatetimeToOppos < ActiveRecord::Migration[6.0]
  def change
    rename_column :opportunities, :target_completion_date, :target_completion_datetime

    add_column :opportunities, :target_completion_date, :date
  end
end
