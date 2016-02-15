$(document).ready(function(){
    var managerTeam = $('#manager-team');

    $('.sort div').click(function(){
        if ($(this).hasClass('manager')){
            managerTeam.slideDown('slow');
        } else if (!$(this).hasClass('bar')){
            managerTeam.slideUp('slow');
        }
    })

});