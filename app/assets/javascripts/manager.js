$(document).ready(function(){
    var employees = $('#manager-team');

    $('.sort div').click(function(){
        if ($(this).hasClass('manager')){
            employees.slideDown('slow');
        } else if (!$(this).hasClass('bar')){
            employees.slideUp('slow');
        }
    });

    $('#manager-team .employee').click(function(){
        $('#viewing-as').remove();
        var name = $(this).find('.name').text();
        var viewAs = "<div id='viewing-as'><div class='text'>" + name + "</div><div class='delete'>x</div></div>";
        $('.column#middle').prepend(viewAs);
    });

    $('.sort').not('.manager').click(function(){
        $('#viewing-as').remove();
    });

});
