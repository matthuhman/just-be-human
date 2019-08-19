class CreateMilestoneRoles < ActiveRecord::Migration[5.2]
  def change
    create_table :milestone_roles, id: :uuid do |t|
      t.integer :level
      t.string :title
      t.string :note
      t.integer :problem_id
      t.belongs_to :milestone, index: true
      t.belongs_to :user, index: true
      t.timestamps
    end

    add_index :milestone_roles, [:user_id, :milestone_id], unique: true
    add_index :milestone_roles, [:problem_id]
  end
end
