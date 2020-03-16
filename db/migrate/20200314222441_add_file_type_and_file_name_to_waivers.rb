class AddFileTypeAndFileNameToWaivers < ActiveRecord::Migration[6.0]
  def change
    add_column :waivers, :file_type, :string, required: true
    add_column :waivers, :file_name, :string, required: true
  end
end
