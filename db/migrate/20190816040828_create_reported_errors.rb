class CreateReportedErrors < ActiveRecord::Migration[5.2]
  def change
    create_table :reported_errors do |t|
      t.string :source
      t.text :errors
      t.integer :priority
      t.timestamps


      t.index :source
      t.index :priority
    end
  end
end
