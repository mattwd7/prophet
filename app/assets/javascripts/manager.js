$(document).ready(function(){
    var employeesPanel = $('#manager-team');

    $('.sort div').click(function(){
        if ($(this).hasClass('manager')){
            employeesPanel.slideDown('slow');
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
        $('#filter-tags').prepend(viewAs);
        checkFilterTagDisplay();
    });

    $('.sort').not('.manager').click(function(){
        $('#viewing-as').remove();
        $('#manager-team .employee.selected').removeClass('selected');
        checkFilterTagDisplay();
    });

});
