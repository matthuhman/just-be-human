class CreateRoles < ActiveRecord::Migration[5.2]
  def change
    create_table :problem_roles, id: :uuid do |t|
      t.integer :level
      t.string :title
      t.string :note
      t.belongs_to :user, index: true
      t.belongs_to :problem, index: true
      t.timestamps
    end

    add_index :problem_roles, [:user_id, :problem_id], unique: true
  end
end
