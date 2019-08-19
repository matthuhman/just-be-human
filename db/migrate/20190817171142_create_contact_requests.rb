class CreateContactRequests < ActiveRecord::Migration[5.2]
  def change
    create_table :contact_requests, id: :uuid do |t|
      t.boolean :active, default: false
      t.boolean :accepted, default: false
      t.datetime :accept_time

      t.references :requesting_user
      t.references :requested_user
      t.timestamps


      t.index [:requesting_user_id, :requested_user_id], name: "index_requesting_requester"
      t.index [:requested_user_id, :requesting_user_id], name: "index_requested_requesting"

    end
  end
end
