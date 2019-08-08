class CreatePosts < ActiveRecord::Migration[5.2]
  def change
    create_table :posts do |t|
      t.string :title, null: false, default: "Change me!"
      t.text :content, null: false, default: "Add content!"
      t.belongs_to :user, index: true
      t.references :postable, polymorphic: true, index: true
      t.timestamps
    end

    remove_column :comments, :commentable_type
    remove_column :comments, :commentable_id

    change_table :comments do |t|
      t.belongs_to :post, index: true
    end
  end
end
