$(document).ready(function(){

    var filters = {resonance: [], attributes: []};

    $('.filters .number-bubble').click(function(){
        var type = $(this).closest('.feedback-summary').length > 0 ? 'resonance' : 'attribute';
        toggleBubble($(this), type);
    });

    $(document).on('click', '.filter-tag .delete', function(){
        var name = $(this).siblings('.text').text(),
            type = $(this).closest('.resonance-tags').length > 0 ? 'resonance' : 'attribute';
        removeTag(name, type);
    });

    function toggleBubble(elem, type){
        var bubble = $(elem),
            name = bubble.siblings().text().toUpperCase();
        // only 1 resonance bubble can be selected at a time (no hybrid feedbacks per biz logic)
        if (type == 'resonance' && !bubble.hasClass('selected')){
            $('.feedback-summary .number-bubble').removeClass('selected');
            filters.resonance = [];
        }
        if (bubble.hasClass('selected')){
            bubble.removeClass('selected');
            removeTag(name, type);
        } else {
            bubble.addClass('selected');
            createTag(name, type);
        }
    }

    function createTag(name, type){
        var newTag = "<div class='filter-tag'><div class='text'>" + name + "</div><div class='delete'>x</div></div>";
        if (type == 'resonance'){
            $('#filter-tags .resonance-tags .filter-tag').remove();
            $('#filter-tags .resonance-tags').append(newTag);
            filters.resonance.push(name);
            filterFeedbacks();
        } else {
            // append to attributes
        }
    }

    function removeTag(name, type){
        if (type == 'resonance'){
            $(".resonance-tags .filter-tag:contains(" + name + ")").remove();
            filters.resonance = [];
            filterFeedbacks();
        } else {
            // remove attribute tag
        }
    }

    function filterFeedbacks(){
        $.ajax({
            method: 'post',
            url: '/filter_feedbacks',
            data: filters,
            beforeSend: function(){
                $(".column#middle").addClass('blur');
            },
            success: function(data){
                $('#feedbacks').html(data);
                $(".column#middle").removeClass('blur');
            }
        })
    }

});