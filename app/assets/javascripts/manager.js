$(document).ready(function(){
    var employees = $('#manager-team');

    $('.sort div').click(function(){
        if ($(this).hasClass('manager')){
            employees.slideDown('slow');
        } else if (!$(this).hasClass('bar')){
            employees.slideUp('slow');
        }
    })

});
