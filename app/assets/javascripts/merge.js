$(document).ready(function(){

    var backdrop_elements = $("#banner, .column#left, .column#middle > *:not(#feedbacks), .feedback"),
        feedbacks = $('.feedback'),
        feedback_1_id = null,
        feedback_2_id = null;


    feedbacks.draggable({
        addClasses: false,
        handle: '.action.merge',
        zIndex: 1000,
        revert: function(socketObj) {
            if (socketObj === false) {
                console.log(socketObj);
                // Drop was rejected, revert the helper.
                var $helper = $("#mydrag");
                $helper.fadeOut("slow").animate($helper.originalPosition);
                return true;
            } else {
                // Drop was accepted, don't revert.
                return false;
            }
        },
        start: function(event, ui){
            backdrop_elements.not($(this)).addClass('drag-backdrop');
            feedbacks.not($(this)).addClass('drop-target');
            feedback_1_id = getRecordID($(this));
        },
        stop: function(event, ui){
            backdrop_elements.not($(this)).removeClass('drag-backdrop');
            feedbacks.not($(this)).removeClass('drop-target');
        }
    });

    feedbacks.droppable({
        hoverClass: 'hover-target',
        drop: function(){
            feedback_2_id = getRecordID($(this));
            $.ajax({
                method: 'post',
                url: '/feedbacks/merge',
                data: {'feedback_1_id': feedback_1_id, 'feedback_2_id': feedback_2_id}
            })
        }
    })

    $('#merge-confirmation').find('.submit-tag').click(function(){
        $.ajax({
            method: 'post',
            url: '/feedbacks/merge',
            data: {'feedback_1_id': feedback_1_id, 'feedback_2_id': feedback_2_id}
        })
    })


});