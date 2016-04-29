$(document).ready(function(){

    var currentUserId = $('.session').attr('id');
    var filters = {resonance: [], user_id: currentUserId};
    var dirtyFilter = false;

    $('.filters .number-bubble').click(function(){
        var type = $(this).closest('.feedback-summary').length > 0 ? 'resonance' : 'attribute';
        toggleBubble($(this), type);
    });

    $(document).on('click', '.tag', function(){
        var name = $(this).text();
        var elem = $('.attribute:contains(' + name + ') .number-bubble');
        toggleBubble(elem, 'attribute');
    });

    $(document).on('click', '.filter-tag .delete', function(){
        var name = $(this).siblings('.text').text(),
            type = $(this).closest('.resonance-tags').length > 0 ? 'resonance' : 'attribute';
        removeTag(name, type);
    });

    function toggleBubble(elem, type){
        var bubble = $(elem),
            name = bubble.siblings().text().toUpperCase();
        if (bubble.hasClass('selected')){
            bubble.removeClass('selected');
            removeTag(name, type);
        } else {
            bubble.addClass('selected');
            createTag(name, type);
        }
        dirtyFilter = true;
    }

    function createTag(name, type){
        var klass = name.toLowerCase();
        var newTag = "<div class='filter-tag'><div class='text " + klass + "'>" + formattedTag(name) + "</div><div class='delete'>X</div></div>";
        $('#filter-tags .resonance-tags').append(newTag);
        filters.resonance.push(name);
        filterFeedbacks();
    }

    function removeTag(name, type){
        $(".resonance-tags .filter-tag:contains(" + formattedTag(name) + ")").remove();
        $(".feedback-summary li:contains(" + toTitleCase(name) + ") .number-bubble").removeClass('selected');
        filters.resonance.splice(filters.resonance.indexOf(name), 1);
        filterFeedbacks();
    }

    function filterFeedbacks(){
        if (filters.resonance.length > 0){
            $('#filter-tags').show();
        } else {
            $('#filter-tags').hide();
        }
        $.ajax({
            method: 'post',
            url: '/filter_feedbacks',
            data: filters,
            beforeSend: function(){
                $(".column#middle").addClass('blur');
            },
            success: function(data){
                if (currentUserId == filters.user_id){
                    $('#feedbacks').html(data.feedbacks);
                } else {
                    var container = getUserFeedbackDiv(filters.user_id);
                    $('#feedbacks div').hide();
                    container.html(data.feedbacks);
                    container.show();
                }
                updateResonanceNumbers(data.resonances);
                if ($('#banner .home').hasClass('selected')){
                    selectBannerTab('home');
                }
                $(".column#middle").removeClass('blur');
                dirtyFilter = false;
            }
        })
    }

    $('.sort .me, .sort .home').click(function(){
        var differentUser = filters.user_id !== currentUserId;
        filters.user_id = currentUserId;
        if (dirtyFilter || differentUser){
            filterFeedbacks();
        } else {
            selectBannerTab($(this).attr('class').match(/me|home/)[0]);
        }
    });

    $('#manager-team').find('.employee').click(function(){
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
        $(".feedback-summary .number-bubble#resonant").text(resonances.resonant);
        $(".feedback-summary .number-bubble#mixed").text(resonances.mixed);
        $(".feedback-summary .number-bubble#isolated").text(resonances.isolated);
    }

    function getUserFeedbackDiv(user_id){
        var feedbacks = $('#feedbacks');
        if (feedbacks.find('.feedbacks#user-' + user_id).length < 1){
            feedbacks.append("<div class='feedbacks' id='user-" + user_id + "'></div>" );
        }
        return feedbacks.find('.feedbacks#user-' + user_id);
    }

});