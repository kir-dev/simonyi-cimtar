// This is a manifest file that'll be compiled into application.js, which will include all the files
// listed below.
//
// Any JavaScript/Coffee file within this directory, lib/assets/javascripts, vendor/assets/javascripts,
// or vendor/assets/javascripts of plugins, if any, can be referenced here using a relative path.
//
// It's not advisable to add code directly here, but if you do, it'll appear at the bottom of the
// the compiled file.
//
// WARNING: THE FIRST BLANK LINE MARKS THE END OF WHAT'S TO BE PROCESSED, ANY BLANK LINE SHOULD
// GO AFTER THE REQUIRES BELOW.
//
//= require jquery
//= require jquery-ui
//= require jquery_ujs
//= require jquery_nested_form
//= require twitter/bootstrap
//= require chosen-jquery
//= require best_in_place
//= require best_in_place.purr
//= require select2
//= require select2_hu
//= require_tree .
// require jquery.ui.datepicker
// require jquery.ui.datepicker-hu
//= require js-routes

$(document).ready(function () {
    jQuery(".best_in_place").best_in_place();

    $("#general-search").select2({
        minimumInputLength: 2,
        placeholder: "Keresés",
        query: function (query) {
            $.ajax({
                url: Routes.search_path(query.term, {format: "json"}),
                dataType: "json",
                success: function (data) {
                    results = [];
                    results.push({text: "Tagok", children: data.members});
                    results.push({text: "Csoportok", children: data.groups});
                    results.push({text: "Cégek", children: data.jobs});

                    query.callback({
                        more: false,
                        results: results
                    });
                }
            });
        },
    })
    $("#general-search").on("change", function (e) {
        var selected = e.val.split("#");
        switch(selected[0]) {
            case "member":
                window.location = Routes.member_path(selected[1]);
                break;
            case "group":
                window.location = Routes.group_path(selected[1]);
                break;
            case "job":
                //window.location = Routes.job_path(selected[1]);
                alert("TODO: kell egy view a munkahely megjelenítésére");
                break;
        }
    });
});
