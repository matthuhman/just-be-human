class NotificationMailerPreview < ActionMailer::Preview
  # hit http://localhost:3000/rails/mailers/devise/mailer/confirmation_instructions



  def notification_email
    NotificationMailer.notification_email(User.first, [], [])
  end

end
