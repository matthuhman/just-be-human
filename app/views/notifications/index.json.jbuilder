json.array! @notifications do |n|
  if n.notifiable.class.name == "Post"
  	notificationString = "#{n.actor.username} #{n.action} a post in #{n.notifiable.postable.title}"
  elsif n.notifiable.class.name == "Requirement"
  	notificationString = "#{n.actor.username} #{n.action} a requirement in #{n.notifiable.opportunity.title}"
  end
  json.url link_to notificationString, url_for(n.notifiable)
  # json.template render partial: "notifications/#{notification.notifiable_type.underscore.pluralize}/#{notification.action}", locals: {notification: notification}, formats: [:html]
end
