$(document).ready(function(){

    var feedbackContent = $('.feedback-form #feedback_content'),
        recipientList = [],
        peers = $('.feedback-form #peers'),
        peerList = [];

    function split( val ) {
        return val.split( /,\s*/ );
    }
    function extractLast( term ) {
        return split( term ).pop();
    }

    feedbackContent.focus(function(){
        $(this).css('line-height', '18px');
    }).blur(function(){
        if ($(this).val().length < 1){
            $(this).css('line-height', '40px');
        }
    });

    feedbackContent.focus(function(){
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
                        var matcher = new RegExp("^" + $.ui.autocomplete.escapeRegex(request.term), "i");
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

    peers.focus(function(){
        if (peerList.length < 1) {
            $.get('/peers', function (data) {
                $.each(data, function (i, user) {
                    peerList.push(user);
                })
            });
            peers
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
                        var re = $.ui.autocomplete.escapeRegex(term);
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

    $('.feedback-form .submit-tag').click(function(){
        $(this).closest('form').submit();
    });
});