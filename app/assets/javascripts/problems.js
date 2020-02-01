

// @mhuhman 20200201 - keeping this around for reference just in case
// $(function(){
//   // @arren reference on certain page only
//   let category = $('#problem_category :selected').val();
//   if (category && problemSub) {
//     let subCategories = JSON.parse(document.querySelector('.sub_categories').dataset.subCategories);
//     changeOptions()

//     return $('#problem_category').change(function(){
//       category = $('#problem_category :selected').val();
//       changeOptions()
//     })

//     function changeOptions(){
//       let mappedSubs = subCategories[category].map((sub, index) => {
//         return `<option value="${index}">${sub.title}</option>`
//       })
//     }
//   }
// })

function showOpportunityInfo() {
  document.getElementById("info-container").style.display = "block";
  document.getElementById("map-container").style.display = "none";
  document.getElementById("posts-container").style.display = "none";
}

function showOpportunityMap() {
  document.getElementById("info-container").style.display = "none";
  document.getElementById("posts-container").style.display = "none";
  document.getElementById("map-container").style.display = "block";
}

function showOpportunityPosts() {
  document.getElementById("info-container").style.display = "none";
  document.getElementById("map-container").style.display = "none";
  document.getElementById("posts-container").style.display = "block";
}
