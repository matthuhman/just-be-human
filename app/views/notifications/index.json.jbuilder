json.array! @notifications do |n|
  notificationString = n.stringify
  if n.notifiable.class.name == "Requirement"
    json.url link_to notificationString, url_for(n.notifiable.opportunity)
  else
    json.url link_to notificationString, url_for(n.notifiable)
  end
end
