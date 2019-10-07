class FixOppoDates < ActiveRecord::Migration[6.0]
  def change


    remove_column :opportunities, :target_completion_datetime if column_exists? :opportunities, :target_completion_datetime

    change_column :opportunities, :target_completion_date, :datetime
  end
end
