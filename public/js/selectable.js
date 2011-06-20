$(document).ready(function() {
    $("tr").click(function(eventObject) {
        $(".selected").removeClass("selected");
        $(this).addClass("selected");

        relPath = $($(this).children("td")[3]).html();
        $.ajax({
            url: "/detail/" + relPath,
            type: "GET",
            success: function(data, textStatus, jqXHR) {
                $("#detail").html(data);
            }
        });
    });
});
