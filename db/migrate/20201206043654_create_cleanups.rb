class CreateCleanups < ActiveRecord::Migration[6.0]
  def change


    create_table :cleanups do |t|
      t.uuid :user_id, null: true
      t.integer :small_bags, default: 0
      t.integer :buckets, default: 0
      t.integer :medium_bags, default: 0
      t.integer :large_bags, default: 0
      t.timestamps
    end


    change_table :coordinates do |t|
      t.remove_references :opportunity
    end

    change_table :coordinates do |t|
      t.belongs_to :cleanup
    end
  end
end
