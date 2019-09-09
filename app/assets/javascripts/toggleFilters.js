let myProbs;
let nearProbs;

let attributes = {
  "problem_volunteers": "volunteers",
  "problem_defined": "defined"
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
  if (document.querySelector("#probs-near-me")){
    nearProbs = [...document.querySelector("#probs-near-me").children]
    myProbs = [...document.querySelector("#my-probs").children]
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
  filterProblems()
}

function handleCheckbox(e) {
  let attribute = attributes[e.target.id]
  filters[attribute] = e.target.checked;
  console.log(filters);

  filterProblems()
}

function handleSelect(e) {
  filters.category = e.target.value

  filterProblems()
}

function filterProblems(){
  nearProbs.forEach(checkProblem)
  myProbs.forEach(checkProblem)
}

function checkProblem(prob) {
  let regFilter = new RegExp(filters.title, 'i')
  let title = prob.querySelector('.problem-title').innerText.toLowerCase()
  prob.style.display = 'block'; // start fresh every time

  if (filters.volunteers && prob.dataset.volunteers === "false") {
    prob.style.display = 'none';
  }
  if (filters.defined && prob.dataset.defined === "false") {
    prob.style.display = 'none';
  }
  if (filters.category !== 'all' && prob.dataset.category !== filters.category) {
    prob.style.display = 'none';
  }
  if (!title.match(regFilter)) {
    prob.style.display = 'none';
  }
}

function traverseToEl(targetClassName, currentEl) {
  if (currentEl.classList.contains(targetClassName)) return currentEl
  currentEl = currentEl.parentElement
  return traverseToEl(targetClassName, currentEl)
}
