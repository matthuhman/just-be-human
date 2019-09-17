class AddPlannedDateToOppos < ActiveRecord::Migration[6.0]
  def change

    change_column :opportunities, :target_completion_date, :datetime
    add_column :opportunities, :planned_by_date, :date

  end
end
