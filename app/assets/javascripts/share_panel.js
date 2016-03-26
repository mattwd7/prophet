$(document).ready(function(){

    var sharePanel = $("#share-panel"),
        additionalPeers = [],
        feedbackID = null;

    $('.feedback').hover(function(){
        feedbackID = $(this).attr('id').match(/\d+/)[0];
        console.log(feedbackID);

        $(this).find('.share').webuiPopover({
            placement: 'right-bottom',
            trigger: 'hover',
            width: 200,
            type: 'async',
            animation: 'pop',
            url: 'feedbacks/' + feedbackID + '/peers',
            offsetLeft: -100,
            content: function(data){
                var html = '<ul>';
                for(var arr_index in data){
                    var user = data[arr_index];
                    html += '<li>' + user.user_tag + '</li>';
                }
                html+='</ul>';
                return html;
            }
        });
    });

    $(document).on('click', '.feedback .action.share', function(){
        var feedback_id = $(this).closest('.feedback').attr('id').match(/\d+$/)[0];
        $('body').children().not('#share-panel').not('.ui-autocomplete').addClass('blur');
        initSharePanel(feedback_id);
    });

    function closeSharePanel(){
        sharePanel.hide();
        $('body').children().removeClass('blur');
    }

    sharePanel.find('.close, .cancel').click(function(){
        closeSharePanel();
    });

    $(document).on('keydown', function(e) {
        if (e.keyCode == 27) {
            closeSharePanel();
        }
    });

    sharePanel.find('.share').click(function(){
        var newPeers = sharePanel.find('textarea').val();
        $.ajax({
            type: 'POST',
            url: '/feedbacks/' + feedbackID + '/share',
            data: {
                'additional_peers': newPeers,
                'id': feedbackID
            },
            success: function(data){
                closeSharePanel();
                $('#feedback-' + feedbackID).find('.peers .number').text(data);
            }
        })
    });

    function initSharePanel(feedback_id){
        var feedback = $('#feedback-' + feedback_id);
        var avatar_src = feedback.find('.top .avatar img').attr('src'),
            address = feedback.find('.top .address').text(),
            timestamp = feedback.find('.top .timestamp').text(),
            content = feedback.find('.top .content').text();
        feedbackID = feedback_id;
        additionalPeers = [];

        sharePanel.find('.avatar img').attr('src', avatar_src);
        sharePanel.find('.address').text(address);
        sharePanel.find('.timestamp').text(timestamp);
        sharePanel.find('.content').text(content);
        sharePanel.find('textarea').val('');

        $.ajax({
            type: 'GET',
            url: '/additional_peers',
            data: { 'id': feedback_id },
            success: function(data){
                $.each(data, function (i, user) {
                    additionalPeers.push(user);
                })
            }
        });

        sharePanel.find('textarea')
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

                    var regex_validated_array = $.grep(additionalPeers, function (user) {
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
                    updateSource($(this));
                    return false;
                }
            })
            .autocomplete( "instance" )._renderItem = function( ul, item ) {
            return $( "<li>" )
                .append( "<div class='avatar'><img src='" + item.avatar_url + "'/></div><div class='info'>" + item.name + "<div class='title'>" + item.title + "</div><div class='user-tag'>" + item.user_tag + "</div></div>" )
                .appendTo( ul );
        };

        sharePanel.show();
        sharePanel.find('textarea').focus();
    }

    function updateSource(inputTarget){
        var subset = [],
            omissionArray = inputTarget.val().split(',');
        omissionArray = omissionArray.map(function(e){ return e.trim() });
        additionalPeers.forEach(function(p){
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

    sharePanel.find('textarea').keyup(function(){
        updateSource($(this));
    });

});