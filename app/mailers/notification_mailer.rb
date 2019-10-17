class NotificationMailer < ApplicationMailer


  def send_daily_notification_emails

    ## these maps will hold our notifications and reminders in an array for each user
    user_notifications = Hash.new

    ## reminders will be a hash with an ID and a MESSAGE, ID will be the Oppo ID and message will be the
    ## message that gets displayed to the user
    user_reminders = Hash.new



    ## we want to include the last 24h and 15min just in case we missed a notification during the last run
    ## this will help make sure we don't miss any notifications
    last_24h_notifications = Notification.where('created_at > ?', (Time.current - 24.hours - 15.minutes))

    last_24h_notifications.each do |n|
      u = n.recipient.email

      if user_notifications[u] == nil
        user_notifications[u] = [n]
      else
        arr = user_notifications[u]
        arr.push(n)
        user_notifications[u] = arr
      end

    end

    puts "user notifications count: #{user_notifications.size}"


    current_opportunities = Opportunity.where('target_completion_date > ?', Time.current)

    two_weeks_away = (Date.today + 2.weeks)

    current_opportunities.each do |o|
      tcd = o.target_completion_date

      tcd = tcd.to_date

      if (tcd + 2.weeks) > two_weeks_away
        user_reminders = add_reminders(o, user_reminders, (tcd - Date.today).to_i)
      end
    end

    puts "user reminders count: #{user_reminders.size}"

    send_emails(user_notifications, user_reminders)

  end

  def add_reminders(oppo, user_reminders, days_away)

    puts "We are #{days_away} days away from #{oppo.title}"

    oppo.opportunity_roles.each do |r|

      u = r.user

      if [1, 2, 3, 4, 7, 10, 14].include? days_away
        if user_reminders[u] == nil
          user_reminders[u] = [{id: oppo.id, message: "#{oppo.title} is #{days_away} days away- is it on your calendar?"}]
        else
          r = user_reminders[u]
          r.push({id: oppo.id, message: "#{oppo.title} is #{days_away} days away - is it on your calendar?"})
          user_reminders[u] = r
        end
      end

    end

    user_reminders
  end


  def send_emails(user_notifications, user_reminders)

    puts "in send_emails method"
    puts "in send_emails, user notifications size: #{user_notifications.size} && user reminders size: #{user_reminders.size}"

    puts "first user_notification: #{user_notifications.first}"
    user_notifications.each do |email|
      puts "sending email to #{email}"
      notifications = user_notifications.delete(email)
      reminders = user_reminders.delete(email)

      notification_email(email, notifications, reminders).deliver_now
    end

    puts "done with user notifications"
    puts "------------------------------------"
    user_reminders.each do |email|
      puts "sending email to #{email}"
      notifications = user_notifications.delete(email)
      reminders = user_reminders.delete(email)

      self.notification_email(email, notifications, reminders).deliver_now
    end

  end


  def notification_email(user, notifications, reminders)
    @notifications = notifications
    @reminders = reminders

    puts "Is this sending??"

    mail(to: user.email, subject: "Your Daily Update")
  end
end
