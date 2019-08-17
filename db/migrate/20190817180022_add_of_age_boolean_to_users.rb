class AddOfAgeBooleanToUsers < ActiveRecord::Migration[5.2]
  def change
    add_column :users, :over_16, :boolean
  end
end
