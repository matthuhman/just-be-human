class AddIndexesToConversations < ActiveRecord::Migration[6.0]
  def change
    add_index :conversations, :author_id
    add_index :conversations, :receiver_id
    add_index :conversations, [:author_id, :receiver_id], unique: true
  end
end
