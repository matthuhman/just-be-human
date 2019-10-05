class NotificationMailer < ApplicationMailer


  def send_daily_notification_emails

    ## these maps will hold our notifications and reminders in an array for each user
    user_notifications = Hash.new
    user_reminders = Hash.new



    ## we want to include the last 24h and 15min just in case we missed a notification during the last run
    ## this will help make sure we don't miss any notifications
    last_24h_notifications = Notification.where('created_at > ?', (Time.current - 24.hours - 15.minutes))

    last_24h_notifications.each do |n|
      u = n.recipient

      if user_notifications[u] == nil
        user_notifications[u] = [n]
      else
        user_notifications[u].push(n)
      end

    end

    current_defined_opportunities = Opportunity.where('defined = true AND target_completion_date > ?', Time.current)

    two_weeks_away = (Date.today + 2.weeks)
    one_week_away = (Date.today + 1.week)
    three_days_away = (Date.today + 3.days)
    one_day_away = (Date.today + 1.day)

    current_defined_opportunities.each do |o|
      tcd = o.target_completion_date

      tcd = tcd.to_date

      if (tcd + 2.weeks) == two_weeks_away
        user_reminders = add_reminders(o, user_reminders, 14)
      elsif (tcd + 1.weeks) == one_week_away
        user_reminders = add_reminders(o, user_reminders, 7)
      elsif (tcd + 3.days) == three_days_away
        user_reminders = add_reminders(o, user_reminders, 3)
      elsif (tcd + 1.day) == one_day_away
        user_reminders = add_reminders(o, user_reminders, 1)
      end
    end


    send_emails(user_notifications, user_reminders)

  end

  def add_reminders(oppo, user_reminders, days_away)

    oppo.opportunity_roles.each do |r|

      u = r.user

      if user_reminders[u] == nil
        user_reminders[u] = ["#{oppo.title} is #{days_away} days away! Don't forget about it!"]
      else
        user_reminders[u].push("#{oppo.title} is #{days_away} days away! Don't forget about it!")
      end
    end

    user_reminders
  end


  def send_emails(user_notifications, user_reminders)

    user_notifications.each do |user|
      notifications = user_notifications.delete(user)
      reminders = user_reminders.delete(user)

      notification_email(user, notifications, reminders)
    end

    user_reminders.each do |user|
      notifications = user_notifications.delete(user)
      reminders = user_reminders.delete(user)

      notification_email(user, notifications, reminders)
    end

  end


  def notification_email(user, notifications, reminders)
    @notifications = notifications
    @reminders = reminders

    mail(to: user.email, subject: "Your daily notifications")
  end
end
