$(document).ready(function(){

    var currentUserId = $('.session').attr('id');
    var filters = {resonance: [], user_id: null, manager: null};
    var dirtyFilter = false;
    var animsition_options = {
        inClass: 'fade-out-down',
        outClass: 'fade-in-up',
        inDuration: 1500,
        outDuration: 2000,
        linkElement: '.animsition-link',
        // e.g. linkElement: 'a:not([target="_blank"]):not([href^="#"])'
        loading: false,
        loadingParentElement: 'body', //animsition wrapper element
        loadingClass: 'animsition-loading',
        loadingInner: '', // e.g '<img src="loading.svg" />'
        timeout: false,
        timeoutCountdown: 5000,
        onLoadEvent: true,
        browser: [ 'animation-duration', '-webkit-animation-duration'],
        // "browser" option allows you to disable the "animsition" in case the css property in the array is not supported by your browser.
        // The default setting is to disable the "animsition" in a browser that does not support "animation-duration".
        overlay : false,
        overlayClass : 'animsition-overlay-slide',
        overlayParentElement : 'body',
        transition: function(url){ window.location.href = url; }
    };

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
            removeTag(name);
        } else {
            bubble.addClass('selected');
            createTag(name);
        }
        dirtyFilter = true;
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
        $(".feedback-summary li:contains(" + toTitleCase(name) + ") .number-bubble").removeClass('selected');
        filters.resonance.splice(filters.resonance.indexOf(name), 1);
        filterFeedbacks();
    }

    function filterFeedbacks(){
        var column = $(".column#middle")
        if (filters.resonance.length > 0){
            $('#filter-tags').show();
        } else {
            $('#filter-tags').hide();
        }
        $.ajax({
            method: 'get',
            url: '/filter_feedbacks',
            data: filters,
            beforeSend: function(){
                $(".column#middle").addClass('blur');
//                $(".column#middle").animsition(animsition_options);
            },
            success: function(data){
                $('#feedbacks').html(data.feedbacks);
                updateResonanceNumbers(data.resonances);
                $(".column#middle").removeClass('blur');
                dirtyFilter = false;
//                $(".column#middle").animsition(animsition_options);
            }
        })
    }

    $('.sort .home').click(function(){
        filters.user_id = null;
        filters.manager = null;
        filterFeedbacks();
    });

    $('.sort .me').click(function(){
        filters.user_id = currentUserId;
        filters.manager = null;
        filterFeedbacks();
    });

    $('.sort .manager').click(function(){
        filters.user_id = null;
        filters.manager = true;
        filterFeedbacks();
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

});