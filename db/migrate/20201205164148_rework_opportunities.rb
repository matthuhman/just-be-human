class ReworkOpportunities < ActiveRecord::Migration[6.0]
  def change

    change_table :opportunities do |t|
      t.remove :cleanup_date
      t.remove :volunteers_required
      t.remove :volunteer_count
      t.remove :completed
      t.remove :address
      t.remove :postal_code
      t.remove :recurring
      t.remove :status
      t.remove :time_zone
      t.remove :organization_id
      t.remove :cleanup_time
      t.remove :cleanup_duration

      t.rename :follower_count, :participants
    end


  end
end
