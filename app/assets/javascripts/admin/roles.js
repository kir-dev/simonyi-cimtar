// Place all the behaviors and hooks related to the matching controller here.
// All this logic will automatically be available in application.js.

$(function() {
    // manage.html.erb
    setup_manage_view();

    // index.html.erb
    setup_index_view();
});

function setup_index_view () {
    $("#submit-search-member").click(function(e) {
        e.preventDefault();
        var term = $("#member_name").val();
        $("#members-contianer").load("/admin/roles/member_search", { member_name: term })
    });
}

function setup_manage_view () {
    $("#role_name").change(function(e) {
        var isRoleGlobal = $(this).children("option:selected").data("global");
        if (isRoleGlobal || typeof(isRoleGlobal) == "undefined") {
            $("#role_group_id").prop("disabled", true);
        } else {
            $("#role_group_id").prop("disabled", false);
        }
    });

    $(".remove-role-link").click(function(e) {
        var link = $(this),
            roleId = link.data("role-id"),
            memberId = link.data("member-id");

        $.ajax({
            url: Routes.admin_role_path(roleId),
            type: "post",
            data: {
                member_id: memberId,
                _method: "delete"
            },
            dataType: "json",
            success: function(data) {
                if (data.success) {
                    // remove the whole row from the list
                    link.parent().remove();
                } else {
                    console.log(data.error_message);
                }
            }
        });
    });
}