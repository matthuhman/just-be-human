class MakeOver16DefaultToNil < ActiveRecord::Migration[5.2]
  def change
    change_column :users, :over_16, :boolean, default: nil
  end
end
