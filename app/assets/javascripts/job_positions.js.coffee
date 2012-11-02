# Place all the behaviors and hooks related to the matching controller here.
# All this logic will automatically be available in application.js.
# You can use CoffeeScript in this file: http://jashkenas.github.com/coffee-script/

#$.datepicker.setDefaults($.datepicker.regional['hu']);

$('#job_position_present').bind 'click', (event) =>
  if ( $('#job_position_present').is(':checked') )
    $('#to_date_container').hide()
  else
    $('#to_date_container').show()
