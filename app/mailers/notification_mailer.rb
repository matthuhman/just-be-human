class NotificationMailer < ApplicationMailer
  default from: 'mailer@justbehuman.io'

  def notification_email(user, notifications, reminders)
    @notifications = notifications
    @reminders = reminders

    mail(to: user.email, subject: "Your Daily Volunteering Update")
  end


  def local_oppos_email(user, opportunities)
    @user = user
    @opportunities = opportunities

    mail(to: user.email, subject: "New Opportunities Near You")
  end
end
