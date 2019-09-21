$("#conversation-body").animate({ scrollTop: $('#conversation-body').scrollTop()}, 1000);






if ($("#conversation-body")) {
  console.log("on conversation#show page");
  var d = $('#conversation-body');
  d.scrollTop(0);
  // console.log(d.scrollTop());
}
