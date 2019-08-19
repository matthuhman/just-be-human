class CreateComments < ActiveRecord::Migration[5.2]
  def change
    create_table :comments, id: :uuid do |t|
      t.text :content
      
      t.belongs_to :user, type: :uuid, index: true
      t.timestamps
    end
  end
end
