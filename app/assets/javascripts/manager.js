$(document).ready(function(){
    var employees = $('#manager-team');

    $('.sort div').click(function(){
        if ($(this).hasClass('manager')){
            employees.slideDown('slow');
            managerSelectPrompt();
        } else if (!$(this).hasClass('bar')){
            employees.slideUp('slow');
        }
    });

    $('#manager-team .employee').click(function(){
        $('#viewing-as').remove();
        $('#manager-team .employee.selected').removeClass('selected');
        $(this).addClass('selected');
        var name = $(this).find('.name').text();
        var viewAs = "<div id='viewing-as'><div class='text'>" + name + "</div></div>";
        $('.column#middle').prepend(viewAs);
    });

    $('.sort').not('.manager').click(function(){
        $('#viewing-as').remove();
    });

    function managerSelectPrompt(){
        var prompt = $("#feedbacks").find('#manager-select-prompt');
        if (prompt.length < 1) {
            $("#feedbacks").append("<div id='manager-select-prompt'>Select an employee to view feedbacks.</div>");
        }
    }

});
