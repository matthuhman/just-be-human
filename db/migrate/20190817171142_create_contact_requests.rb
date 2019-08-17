class CreateContactRequests < ActiveRecord::Migration[5.2]
  def change
    create_table :contact_requests do |t|
      t.references :requesting_user
      t.references :requested_user
      t.timestamps
    end
  end
end
