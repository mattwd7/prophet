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
            success: function(data){
                var feedbackElem = $('#feedback-' + feedback.id);
                feedbackElem.removeClass('fresh');
                feedbackElem.find('.fresh').each(function(){
                    $(this).removeClass('fresh')
                });
                var affected_elements;
                if (data.me_feedback){
                    // feedback belongs to ME, so subtract from both ME and HOME
                    affected_elements = $('.sort .notifications');
                } else {
                    // feedback does not belong to ME, so subtract from just HOME
                    affected_elements = $('.sort .home .notifications');
                }
                var new_count;
                $.each(affected_elements, function(index, elem){
                    new_count = +$(elem).text() - 1;
                    if (new_count < 1){
                        $(elem).css('visibility', 'hidden');
                    } else {
                        $(elem).text( new_count );
                    }
                });
            },
            error: function(){
                alert("error!");
            }
        });
    }

});