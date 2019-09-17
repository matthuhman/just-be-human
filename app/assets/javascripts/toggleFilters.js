let myProbs;
let nearProbs;

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
