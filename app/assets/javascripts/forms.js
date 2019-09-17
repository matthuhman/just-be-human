


// these two functions are used by the Opportunities creation form

function showDefinedOrAbstractOptions()
{
  var checked = document.getElementById('defined-checkbox');

  if (checked.checked)
  {
    document.getElementById('defined-options').style.display = "block";
    document.getElementById('abstract-options').style.display = "none";
    clearOutAbstractOptions();
  }
  else
  {
    document.getElementById('defined-options').style.display = "none";
    document.getElementById('abstract-options').style.display = "block";
    clearOutAbstractOptions();
  }
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