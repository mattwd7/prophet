$(document).ready(function(){

    var follow_ups = $('.follow-up');

    follow_ups.find('.close').click(function(){
        $(this).closest('.follow-up').fadeOut(300);
    });

    follow_ups.find('form').submit(function(){
        var follow_up = $(this).closest('.follow-up');
        follow_up.html("Thank you for following up!");
        follow_up.delay(3000).fadeOut(500);
    })

});