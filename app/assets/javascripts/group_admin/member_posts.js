$(function() {
    $("a[name=manage_link]").live("click", function(e) {
        $(this).siblings("label").children("input").prop("checked", true);
    });
});
