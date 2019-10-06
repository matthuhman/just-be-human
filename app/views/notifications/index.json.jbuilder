json.array! @notifications do |n|
  notificationString = n.stringify
  json.url link_to notificationString, url_for(n.notifiable)
end
