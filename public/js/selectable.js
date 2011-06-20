$(document).ready(function() {
    $("tr").click(function(eventObject) {
        $(".selected").removeClass("selected");
        $(this).addClass("selected");
    });
});
