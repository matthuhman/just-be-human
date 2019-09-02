class AddDefinedToRequirements < ActiveRecord::Migration[6.0]
  def change
    add_column :requirements, :defined, :boolean, default: true
  end
end
