class RemoveOppoIdFromWaivers < ActiveRecord::Migration[6.0]
  def change

    remove_column :waivers, :opportunity_id

  end
end
