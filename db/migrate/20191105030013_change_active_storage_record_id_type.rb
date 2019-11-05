class ChangeActiveStorageRecordIdType < ActiveRecord::Migration[6.0]
  def change
    remove_column :active_storage_attachments, :record_id
    add_column :active_storage_attachments, :record_id, :uuid
  end
end
