class AddExpectedSizeToOppos < ActiveRecord::Migration[6.0]
  def up
    add_column :opportunities, :expected_size, :string
    change_column :opportunities, :bring_your_own, :boolean, default: true
  end

  def down
    remove_column :opportunities, :expected_size
  end
end
