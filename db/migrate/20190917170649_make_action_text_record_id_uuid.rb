class MakeActionTextRecordIdUuid < ActiveRecord::Migration[6.0]
  def change
    remove_column :action_text_rich_texts, :record_id

    add_column :action_text_rich_texts, :record_id, :uuid
    add_index :action_text_rich_texts, [:name, :record_type, :record_id], unique: true, name: "index_action_text_rich_texts_uniqueness"
  end
end
