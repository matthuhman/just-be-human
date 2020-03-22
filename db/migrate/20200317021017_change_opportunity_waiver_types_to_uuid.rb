class ChangeOpportunityWaiverTypesToUuid < ActiveRecord::Migration[6.0]
  def change
    remove_column :opportunity_waivers, :opportunity_id
    add_column :opportunity_waivers, :opportunity_id, :uuid
    remove_column :opportunity_waivers, :waiver_id
    add_column :opportunity_waivers, :waiver_id, :uuid
  end
end
