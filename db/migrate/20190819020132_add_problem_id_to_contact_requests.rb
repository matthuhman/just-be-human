class AddProblemIdToContactRequests < ActiveRecord::Migration[5.2]
  def change
    add_column :contact_requests, :problem_id, :uuid
  end
end
