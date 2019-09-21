class AddArchiveAndCompletionToPosts < ActiveRecord::Migration[6.0]
  def change
    add_column :posts, :archived, :boolean, default: false
    add_column :posts, :completion_post, :boolean, default: false
  end
end
