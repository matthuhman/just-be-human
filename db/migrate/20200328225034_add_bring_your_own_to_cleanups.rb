class AddBringYourOwnToCleanups < ActiveRecord::Migration[6.0]
  def up
    add_column :opportunities, :bring_your_own, :boolean, default: false
  end

  def down
    remove_column :opportunities, :bring_your_own
  end
end
