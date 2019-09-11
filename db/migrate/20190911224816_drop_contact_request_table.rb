class DropContactRequestTable < ActiveRecord::Migration[6.0]
  def change

    drop_table :contact_requests

  end
end
