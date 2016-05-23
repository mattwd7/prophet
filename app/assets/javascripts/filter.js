var wasAdmin = false;

$(document).ready(function(){

    var currentUserId = $('.session').attr('id');
    var filters = {resonance: [], user_id: null, manager: null};
    var dirty_numbers = false;

    $('.filters .number-bubble').click(function(){
        toggleBubble($(this));
    });

    $(document).on('click', '.filter-tag .delete', function(){
        var name = $(this).siblings('.text').text(),
            type = $(this).closest('.resonance-tags').length > 0 ? 'resonance' : 'attribute';
        removeTag(name, type);
    });

    function toggleBubble(elem){
        var bubble = $(elem),
            name = bubble.siblings().text().toUpperCase();
        if (bubble.hasClass('selected')){
            bubble.removeClass('selected');
            bubble.siblings().removeClass('selected');
            removeTag(name);
        } else {
            bubble.addClass('selected');
            bubble.siblings().addClass('selected');
            createTag(name);
        }
    }

    function createTag(name){
        var klass = name.toLowerCase();
        var newTag = "<div class='filter-tag'><div class='text " + klass + "'>" + formattedTag(name) + "</div><div class='delete'>X</div></div>";
        $('#filter-tags .resonance-tags').append(newTag);
        filters.resonance.push(name);
        filterFeedbacks();
    }

    function removeTag(name){
        $(".resonance-tags .filter-tag:contains(" + formattedTag(name) + ")").remove();
        $(".feedback-summary li:contains(" + toTitleCase(name) + ") div").removeClass('selected');
        filters.resonance.splice(filters.resonance.indexOf(name), 1);
        filterFeedbacks();
    }

    $(document).on('transitionend webkitTransitionEnd oTransitionEnd otransitionend MSTransitionEnd', function (e){
        var feedbacks = $('#feedbacks');
        if ($(e.target).attr('id') == feedbacks.attr('id')){
            feedbacks.removeClass('fade-out-down');
            identifyFreshFeedbacks();
        }
    });

    function filterFeedbacks(){
        var feedbacks = $("#feedbacks");
        var animating = false;
        checkFilterTagDisplay();
        $.ajax({
            method: 'get',
            url: '/filter_feedbacks',
            data: filters,
            beforeSend: function(){
                animating = true;
                feedbacks.addClass('fade-out-down');
            },
            success: function(data){
                $('#feedbacks').html(data.feedbacks);
                if (dirty_numbers){
                    updateResonanceNumbers(data.resonances);
                    dirty_numbers = false;
                }
            },
            complete: function(){
                if (!animating || wasAdmin){
                    feedbacks.removeClass('fade-out-down');
                    identifyFreshFeedbacks();
                }
                animating = false;
                wasAdmin = false;
            }
        })
    }

    $('.sort .home').click(function(){
        if (!$(this).attr('class').match(/selected/)) {
            dirty_numbers = true;
            filters.user_id = null;
            filters.manager = null;
            filterFeedbacks();
        }
    });

    $('.sort .me').click(function(){
        if (!$(this).attr('class').match(/selected/)) {
            dirty_numbers = true;
            filters.user_id = currentUserId;
            filters.manager = null;
            filterFeedbacks();
        }
    });

    $('.sort .manager').click(function(){
        if (!$(this).attr('class').match(/selected/)) {
            dirty_numbers = true;
            filters.user_id = null;
            filters.manager = true;
            filterFeedbacks();
        }
    });

    $('#manager-team').find('.employee').click(function(){
        dirty_numbers = true;
        filters = {resonance: [], user_id: $(this).attr('id')};
        filterFeedbacks();
    });

    function toTitleCase(str){
        return str.replace(/\w+/g, function(txt){return txt.charAt(0).toUpperCase() + txt.substr(1).toLowerCase();});
    }

    function formattedTag(tag){
        if (tag[0] === '#'){
            tag = tag.substr(1, tag.length);
        }
        return tag.toUpperCase();
    }

    function updateResonanceNumbers(resonances){
        var feedback_summary = $('.feedback-summary');
        feedback_summary.find('span').fadeOut('fast', function(){
            feedback_summary.find(".number-bubble#resonant span").text(resonances.resonant);
            feedback_summary.find(".number-bubble#mixed span").text(resonances.mixed);
            feedback_summary.find(".number-bubble#isolated span").text(resonances.isolated);
            feedback_summary.find('span').fadeIn('fast');
        });
    }

});

function checkFilterTagDisplay(){
    var filter_tags = $("#filter-tags");
    if (filter_tags.find('.resonance-tags').children().length < 1 && filter_tags.find('#viewing-as').length < 1){
        filter_tags.hide();
    } else {
        filter_tags.show();
    }
}