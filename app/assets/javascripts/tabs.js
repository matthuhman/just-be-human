function openTab(evt, tabName) {
  // Declare all variables
  var i, tabcontent, tablinks;

  // Get all elements with class="tabcontent" and hide them
  tabcontent = document.getElementsByClassName("tabcontent");
  for (i = 0; i < tabcontent.length; i++) {
    tabcontent[i].style.display = "none";
  }

  // Get all elements with class="tablinks" and remove the class "active"
  tablinks = document.getElementsByClassName("tablinks");
  for (i = 0; i < tablinks.length; i++) {
    tablinks[i].className = tablinks[i].className.replace(" active", "");
  }

  // Show the current tab, and add an "active" class to the button that opened the tab
  document.getElementById(tabName).style.display = "block";
  evt.currentTarget.className += " active";
}

function init() {
  const opener = document.getElementById("defaultOpen");
  if (opener) opener.click();
}


document.addEventListener('turbolinks:load', init);







// function showOpportunityInfo() {
//   document.getElementById("info-container").style.display = "block";
//   document.getElementById("map-container").style.display = "none";
//   document.getElementById("posts-container").style.display = "none";
// }

// function showOpportunityMap() {
//   document.getElementById("info-container").style.display = "none";
//   document.getElementById("posts-container").style.display = "none";
//   document.getElementById("map-container").style.display = "block";
// }

// function showOpportunityPosts() {
//   document.getElementById("info-container").style.display = "none";
//   document.getElementById("map-container").style.display = "none";
//   document.getElementById("posts-container").style.display = "block";
// }
