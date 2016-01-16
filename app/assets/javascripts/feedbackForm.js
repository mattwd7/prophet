$(document).ready(function(){


    var feedbackContent = $('.feedback-form #feedback_content'),
        recipients = [],
        peers = $('.feedback-form #peers');

    function split( val ) {
        return val.split( /,\s*/ );
    }
    function extractLast( term ) {
        return split( term ).pop();
    }

    $.get('/recipients', function(data) {
        $.each(data, function (i, user) {
            recipients.push(user);
        })
    });

    feedbackContent
        // don't navigate away from the field on tab when selecting an item
        .bind( "keydown", function( event ) {
            if ( event.keyCode === $.ui.keyCode.TAB &&
                $( this ).autocomplete( "instance" ).menu.active ) {
                event.preventDefault();
            }
        })
        .autocomplete({
            source: function( request, response ) {
                var matcher = new RegExp("^" + $.ui.autocomplete.escapeRegex(request.term), "i");
                response( $.grep( recipients, function( item ){
                    return matcher.test( item.user_tag );
                }))
            },
            minLength: 1,
            focus: function() {
                // prevent value inserted on focus
                return false;
            },
            select: function( event, ui ) {
                var terms = split( this.value );
                // remove the current input
                terms.pop();
                // add the selected item
                terms.push( ui.item.value );
                // add placeholder to get the comma-and-space at the end
                terms.push( "" );
                this.user_tag = terms.join( ", " );
                return false;
            }
        })
        .autocomplete( "instance" )._renderItem = function( ul, item ) {
            return $( "<li>" )
                .append( "<div class='avatar'><img src='" + item.avatar_url + "'/></div><div class='info'>" + item.name + "<div class='title'>" + item.title + "</div>" + item.user_tag + "</div>" )
                .appendTo( ul );
        };


//    var recipients = new Bloodhound({
//        datumTokenizer: Bloodhound.tokenizers.whitespace,
//        queryTokenizer: Bloodhound.tokenizers.whitespace,
//        remote: {
//            url: '/recipients'
//        }
//    });
//
//    var peers = new Bloodhound({
//        datumTokenizer: Bloodhound.tokenizers.whitespace,
//        queryTokenizer: Bloodhound.tokenizers.whitespace,
//        remote: {
//            url: '/peers'
//        }
//    });
//
//    $('#feedback_content').typeahead({
//        hint: true,
//        highlight: true,
//        minLength: 1
//    }, {
//        name: 'recipients',
//        display: 'user_tag',
//        source: recipients,
//        limit: 10,
//        templates: {
//            suggestion: Handlebars.compile('<div><img src="{{avatar_url}}"><div class="info"><div class="name">{{name}}</div><div class="title">{{title}}</div><div class="user_tag">{{user_tag}}</div></div></div>')
//        }
//    });
//
//    $('#peers').typeahead({
//        hint: true,
//        highlight: true,
//        minLength: 1
//    }, {
//        name: 'peers',
//        display: 'user_tag',
//        source: peers,
//        limit: 10,
//        templates: {
//            suggestion: Handlebars.compile('<div><img src="{{avatar_url}}"><div class="info"><div class="name">{{name}}</div><div class="title">{{title}}</div><div class="user_tag">{{user_tag}}</div></div></div>')
//        }
//    });

    $('.feedback-form .submit-tag').click(function(){
        $(this).closest('form').submit();
    });
});