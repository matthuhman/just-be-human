class ReqDefaultVolunteerCountChange < ActiveRecord::Migration[6.0]
  def change
    change_column :requirements, :volunteer_count, :integer, default: 0
  end
end
