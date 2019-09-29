class AddRsvpToOppoRoles < ActiveRecord::Migration[6.0]
  def change
    add_column :opportunity_roles, :has_responded, :boolean, default: false
    add_column :opportunity_roles, :is_coming, :boolean, default: false
    add_column :opportunity_roles, :additional_vols, :integer, default: 0
  end
end
