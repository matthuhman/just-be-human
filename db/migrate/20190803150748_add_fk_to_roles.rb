class AddFkToRoles < ActiveRecord::Migration[5.2]
  def change
    change_table :roles do |t|
      t.belongs_to :user, index: true
      t.belongs_to :problem, index: true
    end
  end
end
