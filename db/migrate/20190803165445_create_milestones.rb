class CreateMilestones < ActiveRecord::Migration[5.2]
  def change
    create_table :milestones do |t|
      t.string :title
      t.text :description
      t.boolean :complete
      t.string :current_status

      t.belongs_to :problem, index: true
      t.timestamps
    end
  end
end
