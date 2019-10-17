# Preview all emails at http://localhost:3000/rails/mailers/notification_mailer
class NotificationMailerPreview < ActionMailer::Preview


  def notification_email
    NotificationMailer.notification_email(User.first, [], [{id: 1, message: "Don't forget about the Trash Pickup opportunity in #{((Date.today + 7.days) - Date.today).to_i} days!"}])
  end

end
