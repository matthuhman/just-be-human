class CreateRoles < ActiveRecord::Migration[5.2]
  def change
    create_table :roles do |t|
      t.integer :level
      t.string :title
      t.belongs_to :user, index: true
      t.belongs_to :problem, index: true
      t.timestamps
    end

    add_index :roles, [:user_id, :problem_id], unique: true
  end
end
