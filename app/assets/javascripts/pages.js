





function hideAboutUsIfNecessary() {
  var els = $('#geopoint-is-present');
  if (els.length > 0) {
    $('#calendar-aboutus').hide();
  }
}
