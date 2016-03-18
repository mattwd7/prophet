$(document).ready(function(){
    var employeesPanel = $('#manager-team');

    $('.sort div').click(function(){
        if ($(this).hasClass('manager')){
            employeesPanel.slideDown('slow');
            managerSelectPrompt();
        } else if (!$(this).hasClass('bar')){
            employeesPanel.slideUp('slow');
        }
    });

    employeesPanel.find('.employee').click(function(){
        $('#viewing-as').remove();
        $('#manager-team .employee.selected').removeClass('selected');
        $(".feedback-summary .number-bubble").removeClass('selected');
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
