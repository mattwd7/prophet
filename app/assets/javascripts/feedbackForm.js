$(document).ready(function(){

    var feedbackContentForm = $('.feedback-form #feedback_content'),
        recipientList = [],
        peersForm = $('.feedback-form #peers'),
        peerList = [];

    // styling toggle for centering placeholder text
    $(document).on('click, focus', '.feedback-form', function(){
        $(this).addClass('active');
    }).on('blur', '.feedback-form', function(){
        $(this).removeClass('active');
    });

//    $('.feedback-form .top').webuiPopover({
//        placement: 'right-bottom',
//        trigger: 'sticky',
//        width: 200,
//        type: 'html',
//        url: $('#error-messages')
//    });

    feedbackContentForm.elastic();
    feedbackContentForm.keyup(function(){
        var submit_button = $(this).closest('.feedback-form').find('.submit-tag');
        if ($(this).val().length > 0){
            submit_button.addClass('active');
            submit_button.attr('tabindex', 0);
        } else {
            submit_button.removeClass('active');
            submit_button.attr('tabindex', '');
        }
    });

    feedbackContentForm.focus(function(){
        if (recipientList.length < 1) {
            $.get('/recipients', function (data) {
                $.each(data, function (i, user) {
                    recipientList.push(user);
                })
            });
            $(this)
                .bind( "keydown", function( event ) {
                    if ( event.keyCode === $.ui.keyCode.TAB &&
                        $( this ).autocomplete( "instance" ).menu.active ) {
                        event.preventDefault();
                    }
                })
                .autocomplete({
                    source: function( request, response ) {
                        var term = request.term;
                        term = term.substring(term.lastIndexOf('@'));
                        var matcher = new RegExp($.ui.autocomplete.escapeRegex(term.replace(' ', '')), "i");
                        response( $.grep( recipientList, function( item ){
                            return matcher.test( item.user_tag );
                        }))
                    },
                    minLength: 1,
                    focus: function() {
                        // prevent value inserted on focus
                        return false;
                    },
                    select: function( event, ui ) {
                        // replace existing or just complete it
                        var content = $(this).val(),
                            existingTag = content.match(/@\w+\s/),
                            newTag = ui.item.user_tag + ' ';
                        if (existingTag){
                            content = content.replace(existingTag[0], newTag);
                        } else {
                            content = newTag + content;
                        }
                        content = content.substring(0, content.lastIndexOf('@')-1) + ' ';
                        $(this).val(content);
                        return false;
                    }
                })
                .autocomplete( "instance" )._renderItem = function( ul, item ) {
                return $( "<li>" )
                    .append( "<div class='avatar'><img src='" + item.avatar_url + "'/></div><div class='info'>" + item.name + "<div class='title'>" + item.title + "</div><div class='user-tag'>" + item.user_tag + "</div></div>" )
                    .appendTo( ul );
            };
        }
    });

    peersForm.focus(function(){
        if (peerList.length < 1) {
            $.get('/peers', function (data) {
                $.each(data, function (i, user) {
                    peerList.push(user);
                })
            });
            $(this)
                .bind( "keydown", function( event ) {
                    if ( event.keyCode === $.ui.keyCode.TAB &&
                        $( this ).autocomplete( "instance" ).menu.active ) {
                        event.preventDefault();
                    }
                })
                .autocomplete({
                    source: function( request, response ) {
                        var term = request.term;

                        // substring of new string (only when a comma is in string)
                        if (term.indexOf(', ') > 0) {
                            var index = term.lastIndexOf(', ');
                            term = term.substring(index + 2);
                        }

                        // regex to match string entered with start of suggestion strings
                        var re = $.ui.autocomplete.escapeRegex(term.replace(' ', ''));
                        var matcher = new RegExp('^' + re, 'i');

                        var regex_validated_array = $.grep(peerList, function (user) {
                            return matcher.test(user.user_tag);
                        });

                        response(regex_validated_array);
                    },
                    minLength: 1,
                    focus: function() {
                        // prevent value inserted on focus
                        return false;
                    },
                    select: function( event, ui ) {
                        var terms = split(this.value);
                        terms.pop();
                        terms.push(ui.item.user_tag);
                        terms.push('');
                        this.value = terms.join(', ');
                        updateSource(peersForm);
                        return false;
                    }
                })
                .autocomplete( "instance" )._renderItem = function( ul, item ) {
                    return $( "<li>" )
                    .append( "<div class='avatar'><img src='" + item.avatar_url + "'/></div><div class='info'>" + item.name + "<div class='title'>" + item.title + "</div><div class='user-tag'>" + item.user_tag + "</div></div>" )
                    .appendTo( ul );
            };
        }
    });

    function updateSource(inputTarget){
        var subset = [],
            omissionArray = inputTarget.val().split(','),
            recipient = feedbackContentForm.val().match(/@\S+/);
        if (recipient != null){
            omissionArray.push(recipient[0]); // do not include the recipient of the feedback
        }
        omissionArray = omissionArray.map(function(e){ return e.trim() });
        peerList.forEach(function(p){
            if (omissionArray.indexOf(p.user_tag) < 0 ){
                subset.push(p);
            }
        });
        inputTarget.autocomplete('option', 'source', function( request, response ) {
            var term = request.term;

            // substring of new string (only when a comma is in string)
            if (term.indexOf(', ') > 0) {
                var index = term.lastIndexOf(', ');
                term = term.substring(index + 2);
            }

            // regex to match string entered with start of suggestion strings
            var re = $.ui.autocomplete.escapeRegex(term.replace(' ', ''));
            var matcher = new RegExp('^' + re, 'i');

            var regex_validated_array = $.grep(subset, function (user) {
                return matcher.test(user.user_tag);
            });

            response(regex_validated_array);
        });
    }

    peersForm.keyup(function(){
        updateSource($(this));
    });

});

function split( val ) {
    return val.split( /,\s*/ );
}
function extractLast( term ) {
    return split( term ).pop();
}