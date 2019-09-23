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
//= require introjs
//= require trix/dist/trix
//= require conversations
//= require ahoy

import ahoy from "ahoy.js";

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


// and check for it when deciding whether to start.
window.addEventListener('load', function() {
  var path = window.location.pathname;

  // return if path doesn't have an intro or if we've already shown it
  // on this browser
  if (!hasIntro(path)) return;
  if (localStorage.getItem(path) === 'done') return;

  intro = introJs();

  intro.setOptions(getSteps(path));
  //add a flag when we're done
  intro.oncomplete(function() {
    localStorage.setItem(window.location.pathname, 'done');
  });

  // add a flag when we exit
  intro.onexit(function() {
     localStorage.setItem(window.location.pathname, 'done');
  });


  intro.start();
});


function hasIntro(path)
{
  var shouldIntro = false;
  switch (path) {
    case "/":
      return true;
    case "/opportunities/new":
      return true;
    default:
      return false;
  }
}


function getSteps(path)
{
  switch (path) {
    case "/":
      return
      {
        steps: [
          {
            intro: "Welcome to Just Be Human! This platform is designed to allow you to quickly and easily define volunteer opportunities in your local community!"
          },
          {
            element: '#home-step1',
            intro: 'You can click the logo at any time to return to this page.'
          },
          {
            element: '#home-step2',
            intro:"Have a new volunteer opportunity in mind? You can define it by clicking this button."
          },
          {
            element: '#home-step3',
            intro: "You can use this to change the postal code you're viewing opportunities for."
          },
          {
            element: '#home-step4',
            intro: "You can use these buttons to switch between the lists of opportunities near you and those you're already following or volunteering for."
          },
          {
            element: document.querySelectorAll('#home-step5')[0],
            intro: "Select an opportunity to learn more!"
          }
        ]
      }
      break;
    case "/opportunities/new":
      return
      {
        steps: [
          {
            intro: "This page lets you define a new volunteer opportunity!"
          },
          {
            element: '#new-opportunity-step1',
            intro: "Specify a title, description, and category here. A simple title and informative description will be very helpful for finding volunteers!"
          },
          {
            element: '#new-opportunity-step2',
            intro: "If you know exactly what your opportunity requires, select 'defined'. If you're still figuring it out, leave the checkbox blank."
          },
          {
            element: '#new-opportunity-step3',
            intro: "Using a street address is much better than a postal code. If you don't know an exact address, pick a public park or landmark nearby!"
          }
        ]
      }
    default:
      return {};
  }
}





function showStepOne(isForward)
{
  setShownOption(0, isForward);
}

function showStepTwo(isForward)
{
  setShownOption(1, isForward);
}

function showStepThree(isForward)
{
  setShownOption(2, isForward);
}



function setShownOption(showIndex, isForward)
{
  var optionEls = document.querySelectorAll('[id^=oppo-creation-step-');
  for (var i=0; i < optionEls.length; i++)
  {
    if (i == showIndex) {
      optionEls.item(i).style.display = "block";
    }
    else
    {
      optionEls.item(i).style.display = "none";
    }

    // IF WE ARE NOT SHOWING OPTION 2 (defined/abstract options),
    // HIDE BOTH ABSTRACT AND DEFINED OPTIONS

    if (i == 1 && showIndex != 1)
    {
      // if we're going forward, DO NOT CLEAR OPTIONS
      hideAndClearAbstractOptions(!isForward);
      hideDefinedOptions();
    }
  }
}


function chooseDefined()
{
  hideStepTwo();
  document.getElementById('defined-checkbox').checked = true
  showDefinedOptions();
}

function chooseAbstract()
{
  hideStepTwo();

  document.getElementById('defined-checkbox').checked = false;
  showAbstractOptions();
}

function hideStepTwo()
{
  console.log('should be hiding step 2');
  document.getElementById('oppo-creation-step-2').style.display = "none";
}


function showDefinedOptions()
{
  document.getElementById('defined-options').style.display = "block";
}

function showAbstractOptions()
{
  console.log('showing abstract options')
  document.getElementById('abstract-options').style.display = "block";
}

// // these two functions are used by the Opportunities creation form
// function showDefinedOrAbstractOptions()
// {
//   var checkbox = document.getElementById('defined-checkbox');

//   if (checkbox.checked)
//   {
//     showDefinedOptions();
//     hideAndClearAbstractOptions(true);
//   }
//   else
//   {
//     showAbstractOptions();
//     hideDefinedOptions();
//     clearOutAbstractOptions(true);
//   }
// }

function hideAndClearAbstractOptions(shouldClear)
{
  if (shouldClear) {
    clearOutAbstractOptions();
  }
  document.getElementById('abstract-options').style.display = "none";
}

// we don't need to clear defined options as all Abstract oppos
// will still use all the same defined options, they just have some
// extras
function hideDefinedOptions()
{
  document.getElementById('defined-options').style.display = "none";
}

function clearOutAbstractOptions()
{
  // this returns all planned_by_date fields and then nulls them out so that @defined
  // Opportunities don't get have a planned_by_date if the person changes their mind about
  // the Oppo type
  var dateElements = document.querySelectorAll('[id^=opportunity_planned_by_date]');
  for (var i=0; i < dateElements.length; i++)
  {
    var el = dateElements.item(i);
    el.value = '';
  }

  dateElements = document.querySelectorAll('[id^=opportunity_target_completion_date]');
  for (var i=0; i < dateElements.length; i++)
  {
    var el = dateElements.item(i);
    el.value = '';
  }

  document.getElementById('opportunity_estimated_work').value = '';
}


function showOrHideTimeOptions()
{
  var checkbox = document.getElementById('datetime-required');

  if (checkbox.checked)
  {
    document.getElementById('opportunity_target_completion_date_4i').style.display = "block";
    document.getElementById('opportunity_target_completion_date_5i').style.display = "block";
  }
  else
  {
    clearHourAndMinute();
    document.getElementById('opportunity_target_completion_date_4i').style.display = "none";
    document.getElementById('opportunity_target_completion_date_5i').style.display = "none";
  }
}


function clearHourAndMinute()
{
  document.getElementById('opportunity_target_completion_date_4i').value = '12';
  document.getElementById('opportunity_target_completion_date_5i').value = '00';
}



function openTab(evt, cityName) {
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
  document.getElementById(cityName).style.display = "block";
  evt.currentTarget.className += " active";
}

function init() {
  const opener = document.getElementById("defaultOpen");
  if (opener) opener.click();
}

document.addEventListener('DOMContentLoaded', init)

$(document).on("turbolinks:load", init)






// let myProbs;
// let nearProbs;

let attributes = {
  "opportunity_volunteers": "volunteers",
  "opportunity_defined": "defined"
}

let filters = {
  title: '',
  volunteers: false,
  defined: false,
  category: 'all'
}

document.addEventListener('DOMContentLoaded', getProbs)
$(document).on("turbolinks:load", getProbs)


function getProbs(){
  if (document.querySelector("#opps-near-me")){
    nearProbs = [...document.querySelector("#opps-near-me").children]
    myProbs = [...document.querySelector("#my-opps").children]
  }
}


function toggleFilter(e){

  if (e.target.tagName === "FORM" || e.target.tagName === "INPUT" || e.target.tagName === "LABEL" || e.target.tagName === "SELECT"){
    e.stopPropagation()
    return null;
  }

  let target = traverseToEl('filter', e.target)
  if (target.classList.contains('filter')) {
    let filterContainer = target.querySelector('.filter-container');

    let open = target.dataset.open
    if (open === 'true') {
      // close the filter section, remove the checkboxes - etc
      target.dataset.open = 'false'
      target.classList.remove('show-filter')
      filterContainer.classList.remove('show')
    } else {
      // open the filter section, add the filterable stuff
      target.dataset.open = 'true'
      target.classList.add('show-filter')
      filterContainer.classList.add('show')
    }
  }
}

function handleTextInput(e) {
  let val = e.target.value.toLowerCase()

  filters.title = val
  filterOpportunities()
}

function handleCheckbox(e) {
  let attribute = attributes[e.target.id]
  filters[attribute] = e.target.checked;

  filterOpportunities()
}

function handleSelect(e) {
  filters.category = e.target.value

  filterOpportunities()
}

function filterOpportunities(){
  nearProbs.forEach(checkOpportunity)
  myProbs.forEach(checkOpportunity)
}

function checkOpportunity(opp) {
  let regFilter = new RegExp(filters.title, 'i')
  let title = opp.querySelector('.opportunity-title').innerText.toLowerCase()
  opp.style.display = 'block'; // start fresh every time

  if (filters.volunteers && opp.dataset.volunteers === "false") {
    opp.style.display = 'none';
  }
  if (filters.defined && opp.dataset.defined === "false") {
    opp.style.display = 'none';
  }
  if (filters.category !== 'all' && opp.dataset.category !== filters.category) {
    opp.style.display = 'none';
  }
  if (!title.match(regFilter)) {
    opp.style.display = 'none';
  }
}

function traverseToEl(targetClassName, currentEl) {
  if (currentEl.classList.contains(targetClassName)) return currentEl
  currentEl = currentEl.parentElement
  return traverseToEl(targetClassName, currentEl)
}

