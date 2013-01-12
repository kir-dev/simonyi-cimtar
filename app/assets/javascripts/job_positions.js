// Place all the behaviors and hooks related to the matching controller here.
// All this logic will automatically be available in application.js.
// You can use CoffeeScript in this file: http://jashkenas.github.com/coffee-script/

//$.datepicker.setDefaults($.datepicker.regional['hu'])
//
//$.datepicker.setDefaults({
//changeMonth: true,
//changeYear: true,
//dateFormat: "yy-MM",
//disabled: false,
//yearRange: "1990:2025",
//minDate: "1990",
//maxDate: "2025",
//})

$('#job_position_present_job').bind('click', function (event) {
  if ($('#job_position_present_job').is(':checked'))
    $('#to_date_container').hide()
  else
    $('#to_date_container').show()
});
