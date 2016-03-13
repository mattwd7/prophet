$(document).ready(function(){

    var bannerHeight = $('#banner').height(),
        freshFeedbacks = $.map($('.feedback.fresh'), (function(elem){
            return { id: $(elem).attr('id').match(/\d+/)[0],
                    basePosition: $(elem).offset().top + $(elem).height() };
        }));

    $(document).scroll(function(){
        if (freshFeedbacks.length > 0) {
            if (freshFeedbacks[0].basePosition - (window.pageYOffset - bannerHeight) < screen.height) {
                acknowledgeNotification();
            }
        }
    });

    function acknowledgeNotification(){
        var feedback = freshFeedbacks.splice(0, 1)[0];
        destroyNotifications(feedback);
    }

    function destroyNotifications(feedback){
        $.ajax({
            url: '/feedbacks/' + feedback.id + '/destroy_notifications',
            method: 'POST',
            success: function(){
                var feedbackElem = $('#feedback-' + feedback.id);
                feedbackElem.removeClass('fresh');
                feedbackElem.find('.fresh').each(function(){
                    $(this).removeClass('fresh')
                });
                var notificationsDisplay = $('.sort .selected .notifications'),
                    newCount = +notificationsDisplay.text() - 1;
                notificationsDisplay.text(newCount);
                if (newCount < 1){
                    notificationsDisplay.css('visibility', 'hidden');
                }
            },
            error: function(){
                alert("error!");
            }
        });
    }

});