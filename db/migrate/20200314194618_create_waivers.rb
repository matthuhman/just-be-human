class CreateWaivers < ActiveRecord::Migration[6.0]
  def change
    create_table :waivers, id: :uuid do |t|
      t.string :file_hash, required: true
      t.string :title, required: true
      t.string :location, required: true


      t.string :description


      t.boolean :is_public, default: false
      t.boolean :is_general_purpose, default: false

      t.belongs_to :user
      t.references :opportunity, index: true

      t.timestamps
    end


    create_table :opportunity_waivers, id: :uuid do |t|

      t.belongs_to :opportunity, index: true
      t.belongs_to :waiver, index: true

      t.timestamps
    end

    add_index :opportunity_waivers, [:opportunity_id, :waiver_id], unique: true
  end
end
