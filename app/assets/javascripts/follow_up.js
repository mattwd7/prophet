$(document).ready(function(){

    var follow_ups = $('.follow-up'),
        parting_text = "Thank you for following up!";

    follow_ups.find('.close').click(function(){
        var follow_up = $(this).closest('.follow-up');
        parting_text = "You can always follow-up with a comment at a later time!";
        follow_up.find('form').submit();
    });

    follow_ups.find('form').submit(function(){
        var follow_up = $(this).closest('.follow-up');
        follow_up.html(parting_text);
        follow_up.delay(3000).fadeOut(500);
        parting_text = "Thank you for following up!";
    })

});