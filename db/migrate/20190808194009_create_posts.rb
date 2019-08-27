class CreatePosts < ActiveRecord::Migration[5.2]
  def change
    create_table :posts, id: :uuid do |t|
      t.string :title, null: false
      t.text :content, null: false
      t.integer :comment_count, default: 0
      
      t.belongs_to :user, type: :uuid, index: true
      t.references :postable, type: :uuid, polymorphic: true, index: true
      t.timestamps
    end


    change_table :comments do |t|
      t.belongs_to :post, type: :uuid, index: true
    end
  end
end
