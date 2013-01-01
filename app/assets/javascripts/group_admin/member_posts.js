var manage_counter = 0;

$("input[name=manage]").live("click", function(e) {
    var chbox = $(this);
    if (chbox.is(":checked")) {
        chbox.parent().prev("select").prop("disabled", true);
    } else {
        chbox.parent().prev("select").prop("disabled", false);
    }
});
