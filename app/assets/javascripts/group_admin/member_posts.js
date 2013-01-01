var manage_counter = 0;

$(document).on('nested:fieldAdded', function(event){
  // this field was just inserted into your form
  var field = event.field; 
  // if "manage" checkbox is checked, disable the selector
  field.find("input[type=checkbox]").click(function(e) {
    var chbox = $(this);
    if (chbox.is(":checked")) {
        chbox.parent().prev("select").prop("disabled", true);
    } else {
        chbox.parent().prev("select").prop("disabled", false);
    }
  });
})
