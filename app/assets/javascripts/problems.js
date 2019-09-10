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
