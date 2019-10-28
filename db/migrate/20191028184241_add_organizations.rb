class AddOrganizations < ActiveRecord::Migration[6.0]
  def change

    create_table :organizations, id: :uuid do |t|
      t.string :name
      t.string :city
      t.string :region
      t.string :country
      t.string :website

      t.belongs_to :user, type: :uuid, index: true
    end

    create_table :user_organizations do |t|
      t.belongs_to :user, type: :uuid, index: true
      t.belongs_to :organization, type: :uuid, index: true
    end

    add_column :opportunities, :organization_id, :uuid
  end
end
