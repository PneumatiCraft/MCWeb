$(document).ready(function() {
    $("tr").click(function(eventObject) {
        $(".selected").removeClass("selected");
        $(this).addClass("selected");

        relPath = $($(this).children("td")[3]).html();
        $.ajax({
            url: "/detail/" + relPath,
            success: function(data, textStatus, jqXHR) {
                $("#detail").fadeOut('fast', function() {
                    $("#detail").html(data);
                    $("#detail").fadeIn('fast');
                });
            }
        });
    });
});
