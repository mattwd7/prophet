$(document).ready(function(){

    var backdrop_elements = $("#banner, .column#left, .column#middle > *:not(#feedbacks), .feedback"),
        feedbacks = $('.feedback'),
        feedback_1_id = null,
        feedback_2_id = null,
        revert_duration = 500;


    feedbacks.draggable({
        addClasses: false,
        handle: '.action.merge',
        zIndex: 1000,
        revertDuration: revert_duration,
        revert: 'invalid',
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
    });

    $(document).on('click', '#merge-confirmation .submit-tag', function(){
        $.ajax({
            method: 'post',
            url: '/feedbacks/merge',
            data: {'feedback_1_id': feedback_1_id, 'feedback_2_id': feedback_2_id, 'perform_merge': true}
        })
    });

    $(document).on('click', '#merge-confirmation .close, #merge-confirmation .cancel', function(){
        revert_feedback(feedback_1_id);
    });

    function revert_feedback(feedback_id){
        $('#feedback-' + feedback_id).animate({
            top: 0,
            left: 0
        }, revert_duration)
    }


});