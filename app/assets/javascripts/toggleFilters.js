
function toggleFilter(e){

  if (e.target.tagName === "FORM" || e.target.tagName === "INPUT" || e.target.tagName === "LABEL"){
    e.stopPropagation()
    handleFilterParams(e);
    return null;
  }
  // filter floater
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


function traverseToEl(targetClassName, currentEl) {
  if (currentEl.classList.contains(targetClassName)) return currentEl
  currentEl = currentEl.parentElement
  return traverseToEl(targetClassName, currentEl)
}

function handleFilterParams(e) {
  console.log('filter by:', e.target.name);
  // let target = traverseToEl('filter', e.target)
  // let form = target.querySelector('form');

  // Rails.fire(form, 'submit')
  $("#filter-form").submit()
  // make a get request to
}
