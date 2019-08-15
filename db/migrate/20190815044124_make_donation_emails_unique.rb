class MakeDonationEmailsUnique < ActiveRecord::Migration[5.2]
  def change
    change_column :donations, :email, :string, unique: true
  end
end
