class RemoveDefaultFromPosts < ActiveRecord::Migration[6.0]
  def change
    remove_column :posts, :title
    remove_column :posts, :content

    add_column :posts, :title, :string
    add_column :posts, :content, :text
  end
end
