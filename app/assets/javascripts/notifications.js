$(document).ready(function(){

    var bannerHeight = $('#banner').height(),
        freshFeedbacks = $.map($('.feedback.fresh'), (function(elem){
            return { id: $(elem).attr('id').match(/\d+/)[0],
                    basePosition: $(elem).offset().top + $(elem).height() };
        }));

    $(document).scroll(function(){
        if (freshFeedbacks.length > 0) {
            if (freshFeedbacks[0].basePosition - (window.pageYOffset - bannerHeight) < screen.height) {
                acknowledgeNotification(freshFeedbacks[0])
            }
        }
    });

    function acknowledgeNotification(freshFeedback){
        console.log('ACKNOWLEDGED!');
        freshFeedbacks.splice(0, 1);
        // some other handling code here
    }

});