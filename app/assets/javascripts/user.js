$(function () {
    $("#delete-button").click(function () {
        $("#float-window").css("visibility","visible");
    });

    $("#cancel").click(function () {
        $("#float-window").css("visibility","hidden");
    });
});