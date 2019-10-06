class AddAllowEmailFlagToUsers < ActiveRecord::Migration[6.0]
  def change

    add_column :users, :allow_email, :boolean, default: true


    User.all.each do |u|
      u.allow_email = true
      u.save
    end
  end
end
