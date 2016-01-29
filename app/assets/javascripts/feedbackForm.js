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

    feedbackContentForm.elastic();
    feedbackContentForm.keyup(function(){
        if ($(this).val().length > 0){
            $(this).closest('.feedback-form').find('.submit-tag').addClass('active');
        } else {
            $(this).closest('.feedback-form').find('.submit-tag').removeClass('active');
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
                        var matcher = new RegExp("^" + $.ui.autocomplete.escapeRegex(request.term.replace(' ', '')), "i");
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
                        $(this).val(ui.item.user_tag + ' ');
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

    $('.feedback-form .submit-tag').click(function(){
        if ($(this).hasClass('active')){
            $(this).closest('form').submit();
        }
    });
});

function split( val ) {
    return val.split( /,\s*/ );
}
function extractLast( term ) {
    return split( term ).pop();
}