class AddPhoneAndBirthDateToUsers < ActiveRecord::Migration[5.2]
  def change
    add_column :users, :phone_number, :string
    add_column :users, :birth_date, :date
  end
end
