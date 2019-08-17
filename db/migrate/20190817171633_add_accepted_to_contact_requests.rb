class AddAcceptedToContactRequests < ActiveRecord::Migration[5.2]
  def change
    add_column :contact_requests, :accepted, :boolean, default: false
    add_column :contact_requests, :accept_time, :date
    add_column :contact_requests, :active, :boolean, default: false

    add_index :contact_requests, [:requesting_user_id, :requested_user_id, :active], name: "index_requesting_requester"
    add_index :contact_requests, [:requested_user_id, :requesting_user_id, :active], name: "index_requester_requesting"
  end
end
