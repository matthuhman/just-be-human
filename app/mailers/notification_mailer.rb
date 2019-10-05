class NotificationMailer < ApplicationMailer

  def send_daily_notification_emails


    ## so, what needs to happen?

    ## first, we'll pull a list of all users with notifications and build a map of users
    ## to notification messages

    user_to_notifications = Hash.new


    ## then we need to pull a list of all oppos that have TCD's > now and if any of them
    ## are due in 2 weeks, 1 week, 3 days, or 1 day, then add a notification message for each of them


    ## each OPPO REMINDER will appear at the top of the email, followed by notifications



    ## we want to include the last 24h and 15min just in case we missed a notification during the last run
    ## this will help make sure we don't miss any notifications
    last_24h_notifications = Notification.where('created_at > ?', (Time.current - 24.hours - 15.minutes))

    last_24h_notifications.each do |n|
      u = n.recipient

      if user_to_notifications[u] != nil
        user_to_notifications[u] = [n]
      else
        user_to_notifications[u].push(n)
      end

    end

    current_opportunities = Opportunity.where('target_completion_date > ?', Time.current)


    current_opportunities.each do |o|
      tcd = o.target_completion_date



    end


  end
end
