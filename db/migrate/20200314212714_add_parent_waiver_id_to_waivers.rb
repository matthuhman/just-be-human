class AddParentWaiverIdToWaivers < ActiveRecord::Migration[6.0]
  def change
    add_column :waivers, :parent_waiver_id, :uuid
  end
end
