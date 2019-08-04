class RemoveFollowedProblemsId < ActiveRecord::Migration[5.2]
  def change
    
    remove_foreign_key :users, :followed_problems_id

  end
end
