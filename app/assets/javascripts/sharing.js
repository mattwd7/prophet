$(document).ready(function(){

    var sharePanel = $("#share-panel"),
        shareList = $("#share-list"),
        additionalPeers = [],
        feedbackID = null;

    $(document).on('mouseover', '.feedback', function(){
        feedbackID = getRecordID($(this));

        $(this).find('.vote.agree').webuiPopover({
            cache: false,
            placement: 'vertical',
            trigger: 'hover',
            width: 200,
            type: 'async',
            animation: 'pop',
            url: 'feedbacks/' + feedbackID + '/peers?type=Agree',
            style: 'inverse',
            padding: false,
            content: function(data){
                var html = '<ul class="peers-popover">';
                for(var arr_index in data){
                    if (arr_index > 19) {
                        html += '<li><a>And ' + (data.length - 19) + ' more...</a></li>';
                        break;
                    }
                    var user = data[arr_index];
                    html += '<li>' + user.name + '</li>';
                }
                html+='</ul>';
                return html;
            }
        });

        $(this).find('.vote.peers').webuiPopover({
            placement: 'vertical',
            trigger: 'hover',
            width: 200,
            type: 'async',
            animation: 'pop',
            url: 'feedbacks/' + feedbackID + '/peers',
            style: 'inverse',
            padding: false,
            content: function(data){
                var html = '<ul class="peers-popover">';
                for(var arr_index in data){
                    if (arr_index > 19) {
                        html += '<li><a>And ' + (data.length - 19) + ' more...</a></li>';
                        break;
                    }
                    var user = data[arr_index];
                    html += '<li>' + user.name + '</li>';
                }
                html+='</ul>';
                return html;
            }
        });
    });

    $(document).on('click', '.feedback .vote', function(){
        var feedback_id = $(this).closest('.feedback').attr('id').match(/\d+$/)[0],
            type = $(this).hasClass('agree') ? 'Agree' : 'Peers';
        openModal('share-list');
        $('.webui-popover').hide();
        initShareList(feedback_id, type);
    });

    function initShareList(feedback_id, type){
//        var feedback = $('#feedback-' + feedback_id);
        shareList.find('.header .text').text(type);
        $.ajax({
            type: 'GET',
            url: '/feedbacks/' + feedback_id + '/peers',
            data: { 'type': type },
            success: function(data){
                var userList = shareList.find('ul');
                userList.html('');
                for(var index in data){
                    var user = data[index];
                    userList.append('<li><div class="avatar"><img src="' + user.avatar_url + '"></div><div class="data"><div class="name">' + user.name + '</div><div class="title">' + user.title + '</div></li>')
                }
                openModal('share-list');
            }
        })
    }

    $(document).on('click', '.feedback .action.share', function(){
        var feedback_id = $(this).closest('.feedback').attr('id').match(/\d+$/)[0];
        initSharePanel(feedback_id);
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
                create: function(event, ui){
                    $('.ui-autocomplete').last().addClass('modal-autocomplete');
                },
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

        openModal('share-panel');
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

    sharePanel.find('.share').click(function(){
        var newPeers = sharePanel.find('textarea').val();
        $.post('/feedbacks/' + feedbackID + '/share', {
                'additional_peers': newPeers,
                'id': feedbackID
            })
    });

});