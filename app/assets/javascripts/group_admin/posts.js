// Place all the behaviors and hooks related to the matching controller here.
// All this logic will automatically be available in application.js.

$('#post_old_post').bind('change', function (event) {
  if ($('#post_old_post').is(':checked'))
    $('#post_to_field').show();
  else
    $('#post_to_field').hide();
});
