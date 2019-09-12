class AddStatusesToProblemAndRequirements < ActiveRecord::Migration[6.0]
  def change

    rename_column :requirements, :current_status, :status
    rename_column :requirements, :pct_work_remaining, :pct_done

    add_column :opportunities, :status, :string
  end
end
