class CreateProblems < ActiveRecord::Migration[5.2]
  def change
    create_table :problems do |t|
      t.string :title
      t.text :description
      t.string :location
      t.datetime :target_completion_date
      t.references :user, foreign_key: true

      t.timestamps
    end
  end
end
