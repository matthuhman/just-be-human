class NotificationMailer < ApplicationMailer
  default from: 'mailer@justbehuman.io'

  def notification_email(user, notifications, reminders)
    @notifications = notifications
    @reminders = reminders

    puts "Is this sending??"

    if user.allow_email
      mail(to: user.email, subject: "Your Daily Volunteering Update")
    end
  end
end
