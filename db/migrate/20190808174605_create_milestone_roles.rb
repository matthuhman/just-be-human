class CreateMilestoneRoles < ActiveRecord::Migration[5.2]
  def change
    create_table :milestone_roles do |t|
      t.integer :level
      t.string :title
      t.belongs_to :milestone, index: true
      t.belongs_to :user, index: true
      t.timestamps
    end

    add_index :milestone_roles, [:milestone_id, :user_id], unique: true
  end
end
