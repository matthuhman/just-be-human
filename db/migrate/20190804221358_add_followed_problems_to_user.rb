class AddFollowedProblemsToUser < ActiveRecord::Migration[5.2]
  def change
    change_table :users do |t|
      t.references :followed_problems, foreign_key: {to_table: 'users'}
    end
  end
end
