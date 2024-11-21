// This is a manifest file that'll be compiled into application.js, which will include all the files
// listed below.
//
// Any JavaScript/Coffee file within this directory, lib/assets/javascripts, or any plugin's
// vendor/assets/javascripts directory can be referenced here using a relative path.
//
// It's not advisable to add code directly here, but if you do, it'll appear at the bottom of the
// compiled file. JavaScript code in this file should be added after the last require_* statement.
//
// Read Sprockets README (https://github.com/rails/sprockets#sprockets-directives) for details
// about supported directives.
//
//= require jquery3
//= require jquery_ujs
//= require popper
//= require tether
//= require bootstrap
//= require activestorage
//= require turbolinks
//= require_tree .
//= require chartkick
//= require Chart.bundle
//= require local-time
//= require trix/dist/trix
//= require conversations
//= require ahoy
//= require jstimezonedetect

// 20201204 @muhman - Not sure why I ever put these here? they definitely aren't working. lol
// require("waivers")
// require("pages")

$(document).on('turbolinks:load', function(){
  setTimeZone();
  // hideAboutUsIfNecessary();
});

let intro;

// this will make flash messages disappear after a few seconds on-screen
$(function() {
  setTimeout(function(){
    $('.alert').slideUp(500);
  }, 4000);
});

document.addEventListener('click', function(e) {
  if (document.activeElement.toString() == '[object HTMLButtonElement]') {
   document.activeElement.blur();
 }


});

function setTimeZone() {
  if (!localStorage.getItem('detrashers-time-zone')) {
    var zone = jstz.determine().name();
    localStorage.setItem('detrashers-time-zone', zone);
    return zone;
  } else {
    return localStorage.getItem('detrashers-time-zone');
  }
}
