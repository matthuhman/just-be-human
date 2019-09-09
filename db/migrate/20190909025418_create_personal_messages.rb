class CreatePersonalMessages < ActiveRecord::Migration[6.0]

  # remove_index :conversations, :author_id
  # remove_index :conversations, :receiver_id
  # remove_index :conversations, [:author_id, :receiver_id], unique: true
  # change_column :conversations, :receiver_id, :uuid
  # change_column :conversations, :author_id, :uuid

  # add_index :conversations, :author_id
  # add_index :conversations, :receiver_id
  # add_index :conversations, [:author_id, :receiver_id], unique: true

  def change
    create_table :personal_messages, id: :uuid do |t|
      t.text :body
      t.belongs_to :conversation, null: false, foreign_key: true, type: :uuid
      t.belongs_to :user, null: false, foreign_key: true, type: :uuid

      t.timestamps
    end
  end
end
