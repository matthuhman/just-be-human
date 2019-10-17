namespace :notifications do
  desc "This task is responsible for sending emails to all people with notifications"

  task daily_email_task: :environment do

    puts 'Running daily email task!'
    DailyEmailCron.send_daily_notification_emails
    puts "#{Time.current} email send was a success!"

  end

end
