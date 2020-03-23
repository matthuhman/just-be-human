
document.addEventListener('click', function(e) {
 $('#waiver_waiver_file').change(function() {
    var i = $(this).next('label').clone();
    var fileName = $('#waiver_waiver_file')[0].files[0].name;
    $(this).next('label').text(fileName);
  });
});
