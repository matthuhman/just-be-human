json.array! @notifications do |n|
  if n.notifiable.class.name == "Post"
  	notificationString = "#{n.actor.username} #{n.action} a post in #{n.notifiable.postable.title}"
  elsif n.notifiable.class.name == "Requirement"
  	notificationString = "#{n.actor.username} #{n.action} a requirement in #{n.notifiable.opportunity.title}"
  elsif n.notifiable.class.name == "Opportunity"
  	notificationString = "#{n.actor.username} #{n.action} for #{n.notifiable.title}"
  end
  json.url link_to notificationString, url_for(n.notifiable)
end
