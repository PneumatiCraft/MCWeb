$(document).ready(function() {
    $("#servers tr").each(function(idx, elem) {
        if(idx % 2 == 1) {
            $(elem).css('background-color', '#DDF');
        }
    });
});
