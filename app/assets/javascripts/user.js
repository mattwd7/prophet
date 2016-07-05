$(document).ready(function(){

    $('#settings-menu').find('li').click(function(){
        var options = $('#settings-menu').find('li');
        if (!$(this).hasClass('selected')){
            options.removeClass('selected');
            $('.user-settings').hide();
            $('#' + $(this).attr('class')).show();
            $(this).addClass('selected');
        }
    });

});