// Place all the behaviors and hooks related to the matching controller here.
// All this logic will automatically be available in application.js.

$(function() {
    $("#role_name").change(function(e) {
        var isRoleGlobal = $(this).children("option:selected").data("global");
        if (isRoleGlobal || typeof(isRoleGlobal) == "undefined") {
            $("#role_group_id").prop("disabled", true);
        } else {
            $("#role_group_id").prop("disabled", false);
        }
    });
});