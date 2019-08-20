class AddResponseTimeToContactRequest < ActiveRecord::Migration[5.2]
  def change

    add_column :contact_requests, :response_time, :datetime
    
  end
end
