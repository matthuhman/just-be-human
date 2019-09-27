

$(document).on('ready turbolinks:load', function() {
  getNewNotifications();
  var notifications = $("[data-behavior='notifications']");
  console.log(notifications);
});

$(function() {
  console.log('in notifications function?');
  return Notifications = (function() {
    function Notifications() {
      this.handleSuccess = bind(this.handleSuccess, this);


      getNewNotifications();
      console.log("wtf");
      console.log(this.notifications);
      this.notifications = $("[data-behavior='notifications']");
      if (this.notifications.length > 0) {
        this.handleSuccess(this.notifications.data('notifications'));
      }
    }



function handleSuccess(notifications) {
      var items;
      items = $.map(data, function(notifications) {
        return notifications.template;
      });
      console.log(items);
      $("[data-behavior='unread-count']").text(items.length);
      return $("[data-behavior='notification-items']").append(items);
    };

    return Notifications;

  })();
});


function getNewNotifications() {
  console.log("wtf2");
      return $.ajax({
        url: '/notifications.json',
        dataType: 'JSON',
        method: 'GET',
        success: this.handleSuccess
      });
    };
