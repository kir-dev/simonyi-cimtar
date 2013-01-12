$(document).on('nested:fieldAdded', function(event){
  // this field was just inserted into your form
  var field = event.field; 
  // if "manage" link clicked, check all the checkboxes
  field.find("a[name=manage_link]").click(function(e) {
    $(this).siblings("label").children("input").prop("checked", true);
  });
});
