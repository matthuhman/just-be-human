class AddEditedByToOppoAndReq < ActiveRecord::Migration[6.0]
  def change
    add_column :opportunities, :last_edited_by, :uuid
    add_column :requirements, :last_edited_by, :uuid
  end
end
