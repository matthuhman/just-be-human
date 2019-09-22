

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
