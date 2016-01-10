$(document).ready(function(){

    var filters = {resonance: [], attributes: []};

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
        var klass = '';
        if (type === 'resonance'){
            klass = name.toLowerCase();
        }
        var newTag = "<div class='filter-tag'><div class='text " + klass + "'>" + formattedTag(name) + "</div><div class='delete'>x</div></div>";
        if (type == 'resonance'){
            $('#filter-tags .resonance-tags .filter-tag').remove();
            $('#filter-tags .resonance-tags').append(newTag);
            filters.resonance.push(name);
            filterFeedbacks();
        } else {
            // append to attributes
            $('#filter-tags .attribute-tags').append(newTag);
            filters.attributes.push(name);
            filterFeedbacks();
        }
    }

    function removeTag(name, type){
        if (type == 'resonance'){
            $(".resonance-tags .filter-tag:contains(" + formattedTag(name) + ")").remove();
            $(".feedback-summary li:contains(" + toTitleCase(name) + ") .number-bubble").removeClass('selected');
            filters.resonance = [];
            filterFeedbacks();
        } else {
            // remove attribute tag
            $(".attribute-tags .filter-tag:contains(" + formattedTag(name) + ")").remove();
            $(".attributes li:contains(" + name.toLowerCase() + ") .number-bubble").removeClass('selected');
            filters.attributes.splice(filters.attributes.indexOf(name), 1);
            filterFeedbacks();
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


    function toTitleCase(str){
        return str.replace(/\w+/g, function(txt){return txt.charAt(0).toUpperCase() + txt.substr(1).toLowerCase();});
    }

    function formattedTag(tag){
        tag = tag.substr(1, tag.length);
        return tag.toUpperCase();
    }

});