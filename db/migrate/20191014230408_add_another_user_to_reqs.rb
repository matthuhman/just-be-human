class AddAnotherUserToReqs < ActiveRecord::Migration[6.0]
  def change
    rename_column :requirements, :user_id, :creator_id
    add_column :requirements, :leader_id, :uuid
  end
end
