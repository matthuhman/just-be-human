class FixConversationForeignKeys < ActiveRecord::Migration[6.0]
  def change

    remove_column :conversations, :author_id
    remove_column :conversations, :receiver_id

    add_column :conversations, :author_id, :uuid
    add_column :conversations, :receiver_id, :uuid 
  end
end
