


// document.addEventListener('turbolinks:load', getNewNotifications);

// $(document).on('ready turbolinks:load', function() {
//   var notifications = getNewNotifications();
// });


// function handleSuccess(notifications) {
//   var items;
//   items = $.map(notifications, function(notification) {
//     return addClassName(notification.url);
//   });
//   $("[data-behavior='unread-count']").text(items.length);
//   return $("[data-behavior='notification-items']").append(items);
// };

// function handleError(notifications)
// {
// }

// function getNewNotifications() {
// 	if (gon.auth_token !== 'NONE') {
// 		      return $.ajax({
//         url: '/notifications.json?authenticity_token=' + gon.auth_token,
//         dataType: 'JSON',
//         method: 'GET',
//         success: handleSuccess,
//         error: handleError
//       });
// 	}
// };

// function addClassName(aTag) {
// 	aTag = aTag.replace("<a ", "<a class=\"notification-item\" ");

// 	return "<li>" + aTag + "</li>";
// }

// function markAsRead(noNotifications) {
// 	$.ajax({
// 		url: 'notifications/mark_as_read?authenticity_token=' + gon.auth_token,
// 		method: 'GET'
// 	})
// }
